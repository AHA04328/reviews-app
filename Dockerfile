FROM websphere-liberty:webProfile7
MAINTAINER IBM Java engineering at IBM Cloud
COPY /target/liberty/wlp/usr/servers/defaultServer /config/
# Install required features if not present, install APM Data Collector
## iijima add
ENV SERVERDIRNAME reviews

RUN installUtility install --acceptLicense defaultServer && installUtility install --acceptLicense apmDataCollector-7.4
RUN /opt/ibm/wlp/usr/extension/liberty_dc/bin/config_liberty_dc.sh -silent /opt/ibm/wlp/usr/extension/liberty_dc/bin/silent_config_liberty_dc.txt
# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL

RUN \ 
  if [ $LICENSE_JAR_URL ]; then \
    wget $LICENSE_JAR_URL -O /tmp/license.jar \
    && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
    && rm /tmp/license.jar; \
  fi

## iijima add
ARG service_version
ARG enable_ratings
ARG star_color
ENV SERVICE_VERSION ${service_version:-v1}
ENV ENABLE_RATINGS ${enable_ratings:-false}
ENV STAR_COLOR ${star_color:-black}

