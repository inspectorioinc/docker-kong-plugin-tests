FROM ubuntu:18.04
ARG KONG_VERSION=1.4.0

RUN apt-get -qq update \
 && apt-get -qq -y install curl unzip git openssl libpcre3 procps gettext perl wget build-essential \
 && wget --quiet -O kong-${KONG_VERSION}.bionic.amd64.deb https://bintray.com/kong/kong-deb/download_file?file_path=kong-${KONG_VERSION}.bionic.amd64.deb \
 && dpkg -i kong-${KONG_VERSION}.bionic.amd64.deb \
 && git -c advice.detachedHead=false clone --branch ${KONG_VERSION}  https://github.com/Kong/kong.git \
 && cd /kong && make dependencies

ENV PATH="${PATH}:/usr/local/openresty/bin/"
ENV KONG_TESTS="spec/"

WORKDIR /kong

ADD . .

RUN chmod 770 docker-entrypoint.sh

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

CMD ["/kong/docker-entrypoint.sh"]
