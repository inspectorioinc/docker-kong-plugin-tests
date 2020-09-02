FROM alpine:3.9

ARG KONG_VERSION=2.0.4
ARG GEOIP_LICENSE_KEY
ARG GEOIP_LIB_VER=v1.3.2

RUN apk add --no-cache --virtual .build-deps curl wget gettext tar ca-certificates \
    && curl -sfL "https://bintray.com/kong/kong-alpine-tar/download_file?file_path=kong-$KONG_VERSION.amd64.apk.tar.gz" -o /tmp/kong.tar.gz \
    && mkdir /kong \
    && tar -C /kong -xzf /tmp/kong.tar.gz \
    && cp -r /kong/usr/local/* /usr/local/ \
    && cp -r /kong/etc/* /etc/ \
    && rm -rf /kong \
    && apk add --no-cache \
       libgcc openssl pcre tzdata libcap zip m4 \
       bash build-base gd bsd-compat-headers git libgcc libxslt \
       linux-headers make openssl openssl-dev perl libmaxminddb-dev \
       unzip zlib libressl-dev yaml-dev \
    && mkdir -p "/usr/local/kong" \
    && rm -rf /tmp/kong.tar.gz \
    && kong version \
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

CMD ["/kong/docker-entrypoint.sh"]
