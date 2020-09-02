FROM alpine:3.9

ARG KONG_VERSION=2.0.4
ARG GEOIP_LICENSE_KEY

RUN apk add --no-cache --virtual .build-deps curl wget gettext tar ca-certificates \
    && curl -fL "https://bintray.com/kong/kong-alpine-tar/download_file?file_path=kong-$KONG_VERSION.amd64.apk.tar.gz" -o /tmp/kong.tar.gz \
    && mkdir /kong \
    && tar -C /kong -xzf /tmp/kong.tar.gz \
    && cp -r /kong/usr/local/* /usr/local/ \
    && cp -r /kong/etc/* /etc/ \
    && rm -rf /kong \
    && apk add --no-cache \
       libgcc openssl pcre tzdata libcap zip m4 \
       bash build-base gd bsd-compat-headers git libgcc libxslt \
       linux-headers make openssl openssl-dev perl geoip-dev \
       unzip zlib libressl-dev yaml-dev \
    && mkdir -p "/usr/local/kong" \
    && rm -rf /tmp/kong.tar.gz \
    && kong version \
    && git -c advice.detachedHead=false clone --branch ${KONG_VERSION}  https://github.com/Kong/kong.git \
    && cd /kong && make dependencies \
    && mkdir /plugin

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

CMD ["/kong/docker-entrypoint.sh"]
