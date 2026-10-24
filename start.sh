#!/bin/sh
# Starts EcoTransit on the hosting server.
# On the first start, it loads database/ecotransit_database.sql into the
# online database if the tables aren't there yet. Later starts skip this.
set -e

if [ -n "$DB_URL" ]; then
    # DB_URL looks like: jdbc:mysql://HOST:PORT/DBNAME?sslMode=REQUIRED
    hostport=$(echo "$DB_URL" | sed -E 's#^jdbc:mysql://([^/]+)/.*#\1#')
    dbname=$(echo "$DB_URL" | sed -E 's#^jdbc:mysql://[^/]+/([^?]+).*#\1#')
    host=${hostport%:*}
    port=${hostport##*:}
    [ "$port" = "$hostport" ] && port=3306

    export MYSQL_PWD="$DB_PASSWORD"
    db="mysql -h $host -P $port -u ${DB_USER:-root} --ssl-mode=REQUIRED $dbname"

    echo "EcoTransit: connecting to database $dbname at $host port $port as ${DB_USER:-root}"
    if ! tables=$($db -N -e "SHOW TABLES LIKE 'students'" 2>/tmp/db_error); then
        echo "EcoTransit: could not reach the database. Check DB_URL, DB_USER and DB_PASSWORD."
        echo "EcoTransit: database error was: $(cat /tmp/db_error)"
    elif [ -z "$tables" ]; then
        echo "EcoTransit: empty database found, loading demo data..."
        if $db < /opt/ecotransit/ecotransit_database.sql 2>/tmp/db_error; then
            echo "EcoTransit: demo data loaded."
        else
            echo "EcoTransit: loading demo data failed: $(cat /tmp/db_error)"
        fi
    else
        echo "EcoTransit: database already set up."
    fi
    unset MYSQL_PWD
fi

# Render tells the app which port to use through $PORT.
# Turn off Tomcat's shutdown port so the host only sees the website port.
sed -i "s/port=\"8080\"/port=\"${PORT:-8080}\"/; s/<Server port=\"8005\"/<Server port=\"-1\"/" /usr/local/tomcat/conf/server.xml
exec catalina.sh run
