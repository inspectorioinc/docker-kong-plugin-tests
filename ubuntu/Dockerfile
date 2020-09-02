FROM ubuntu:18.04
ARG KONG_VERSION=2.0.4
ARG GEOIP_LICENSE_KEY
ARG GEOIP_LIB_VER=v1.3.2

RUN apt-get -qq update \
 && apt-get -qq -y install software-properties-common curl unzip git openssl libmaxminddb-dev libpcre3 procps gettext perl wget build-essential libssl-dev m4 \
 && wget --quiet -O kong-${KONG_VERSION}.bionic.amd64.deb https://bintray.com/kong/kong-deb/download_file?file_path=kong-${KONG_VERSION}.bionic.amd64.deb \
 && dpkg -i kong-${KONG_VERSION}.bionic.amd64.deb \
 && git -c advice.detachedHead=false clone --branch ${KONG_VERSION}  https://github.com/Kong/kong.git \
 && cd /kong && make dependencies \
 && cd /tmp/ && curl -sfL https://github.com/anjia0532/lua-resty-maxminddb/archive/$GEOIP_LIB_VER.tar.gz -o geoip.tar.gz \
 && tar -xzvf geoip.tar.gz \
 && mkdir /usr/local/openresty/site/lualib/resty/ && mv lua-resty-maxminddb*/lib/resty/* /usr/local/openresty/site/lualib/resty/ \
 && rm -rf lua-resty-maxminddb*/lib/resty/* geoip.tar.gz && ls -lrt /usr/local/openresty/site/lualib/resty/ \
 && mkdir /plugin


ENV PATH="${PATH}:/usr/local/openresty/bin/"
ENV KONG_TESTS="spec/"

WORKDIR /kong

RUN wget -q -O GeoDb.tar.gz "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&suffix=tar.gz&license_key=$GEOIP_LICENSE_KEY" \
 && tar -xzvf GeoDb.tar.gz \
 && mv ./GeoLite2*/GeoLite2*mmdb /usr/local/kong/ \
 && rm -rf ./GeoLite2* GeoDb.tar.gz

ADD . .

RUN chmod 770 docker-entrypoint.sh

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

CMD ["/kong/docker-entrypoint.sh", "run_tests"]
