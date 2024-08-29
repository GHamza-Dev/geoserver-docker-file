# Dockerfile for GeoServer with CORS enabled
FROM openjdk:11-jre-slim

# Set GeoServer version
ENV GEOSERVER_VERSION=2.25.3

# Install required packages
RUN apt-get update && \
    apt-get install -y wget unzip

# Download and unzip GeoServer
RUN wget https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip && \
    unzip geoserver-${GEOSERVER_VERSION}-bin.zip -d /opt && \
    rm geoserver-${GEOSERVER_VERSION}-bin.zip

# Move files to /opt/geoserver, avoiding self-referential moves
RUN mkdir -p /opt/geoserver && \
    find /opt -maxdepth 1 -mindepth 1 -not -name 'geoserver' -exec mv {} /opt/geoserver/ \;

# List contents to verify
RUN ls -l /opt/geoserver

# Copy modified web.xml to enable CORS
COPY web.xml /opt/geoserver/webapps/geoserver/WEB-INF/web.xml

# Set environment variables for GeoServer
ENV GEOSERVER_HOME /opt/geoserver

# Expose GeoServer port
EXPOSE 8080

# Start GeoServer
CMD ["/opt/geoserver/bin/startup.sh"]
