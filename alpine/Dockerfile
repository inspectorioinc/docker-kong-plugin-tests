FROM alpine:3.9

ARG KONG_VERSION=2.0.4

RUN apk add --no-cache --virtual .build-deps curl wget tar ca-certificates \
    && curl -fL "https://bintray.com/kong/kong-alpine-tar/download_file?file_path=kong-$KONG_VERSION.amd64.apk.tar.gz" -o /tmp/kong.tar.gz \
    && mkdir /kong \
    && tar -C /kong -xzf /tmp/kong.tar.gz && ls -lrt /kong/usr/local/*\
    && cp -r /kong/usr/local/* /usr/local/ \
    && cp -r /kong/etc/* /etc/ \
    && rm -rf /kong \
    && apk add --no-cache \
       libgcc openssl pcre perl tzdata libcap zip m4 gettext \
       bash build-base curl gd bsd-compat-headers git libgcc libxslt \
       linux-headers make nano openssl openssl-dev perl \
       unzip zlib ca-certificates libressl-dev yaml-dev \
    && mkdir -p "/usr/local/kong" \
    && rm -rf /tmp/kong.tar.gz \
    && kong version \
    && git -c advice.detachedHead=false clone --branch ${KONG_VERSION}  https://github.com/Kong/kong.git \
    && cd /kong && make dependencies

ENV PATH="${PATH}:/usr/local/openresty/bin/"
ENV KONG_TESTS="spec/"

WORKDIR /kong

ADD . .

RUN chmod 770 docker-entrypoint.sh

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

CMD ["/kong/docker-entrypoint.sh"]
