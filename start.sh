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

    tables=$($db -N -e "SHOW TABLES LIKE 'students'" 2>/dev/null || echo "error")
    if [ "$tables" = "error" ]; then
        echo "EcoTransit: could not reach the database. Check DB_URL, DB_USER and DB_PASSWORD."
    elif [ -z "$tables" ]; then
        echo "EcoTransit: empty database found, loading demo data..."
        $db < /opt/ecotransit/ecotransit_database.sql
        echo "EcoTransit: demo data loaded."
    else
        echo "EcoTransit: database already set up."
    fi
    unset MYSQL_PWD
fi

# Render tells the app which port to use through $PORT.
sed -i "s/port=\"8080\"/port=\"${PORT:-8080}\"/" /usr/local/tomcat/conf/server.xml
exec catalina.sh run
