# Runs EcoTransit on Tomcat 9 (same family as XAMPP's Tomcat).
# Render builds this file automatically when you deploy.
FROM tomcat:9.0-jdk17-temurin

# MySQL client, used once to load the demo data into the online database.
RUN apt-get update \
 && apt-get install -y --no-install-recommends mysql-client \
 && rm -rf /var/lib/apt/lists/*

# Remove Tomcat's sample apps and install EcoTransit as the main site,
# so it opens at https://your-app.onrender.com/ with no /EcoTransit in the link.
RUN rm -rf /usr/local/tomcat/webapps/*
COPY . /usr/local/tomcat/webapps/ROOT/

# Keep the database file and start script out of the public website.
RUN mkdir -p /opt/ecotransit \
 && mv /usr/local/tomcat/webapps/ROOT/database/ecotransit_database.sql /opt/ecotransit/ \
 && mv /usr/local/tomcat/webapps/ROOT/start.sh /opt/ecotransit/start.sh \
 && chmod +x /opt/ecotransit/start.sh \
 && rm -rf /usr/local/tomcat/webapps/ROOT/src \
           /usr/local/tomcat/webapps/ROOT/database \
           /usr/local/tomcat/webapps/ROOT/Dockerfile \
           /usr/local/tomcat/webapps/ROOT/README.md \
           /usr/local/tomcat/webapps/ROOT/.dockerignore

CMD ["/opt/ecotransit/start.sh"]
