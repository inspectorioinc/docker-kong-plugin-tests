FROM ubuntu:18.04
ARG KONG_VERSION=2.0.4
ARG GEOIP_LICENSE_KEY

RUN apt-get -qq update \
 && apt-get -qq -y install software-properties-common curl unzip git openssl libgeoip-dev libpcre3 procps gettext perl wget build-essential libssl-dev m4 \
 && wget --quiet -O kong-${KONG_VERSION}.bionic.amd64.deb https://bintray.com/kong/kong-deb/download_file?file_path=kong-${KONG_VERSION}.bionic.amd64.deb \
 && dpkg -i kong-${KONG_VERSION}.bionic.amd64.deb \
 && git -c advice.detachedHead=false clone --branch ${KONG_VERSION}  https://github.com/Kong/kong.git \
 && cd /kong && make dependencies

ENV PATH="${PATH}:/usr/local/openresty/bin/"
ENV KONG_TESTS="spec/"

WORKDIR /kong

RUN wget -q -O GeoDb.tar.gz "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&suffix=tar.gz&license_key=$GEOIP_LICENSE_KEY" \
 && tar -xzvf GeoDb.tar.gz \
 && mv ./GeoLite2*/GeoLite2*mmdb /usr/local/kong/ \
 && rm -rf ./GeoLite2* GeoDb.tar.gz

ADD . .

RUN chmod 770 docker-entrypoint.sh

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

CMD ["/kong/docker-entrypoint.sh", "run_tests"]
