#!/bin/bash

export KONG_ADMIN_LISTEN="${KONG_ADMIN_LISTEN:=127.0.0.1:9001}"
export KONG_PROXY_LISTEN="${KONG_PROXY_LISTEN:=0.0.0.0:9000, 0.0.0.0:9443 http2 ssl, 0.0.0.0:9002 http2}"
export KONG_STREAM_LISTEN="${KONG_STREAM_LISTEN:=off}"

export KONG_SSL_CERT="${KONG_SSL_CERT:=spec/fixtures/kong_spec.crt}"
export KONG_SSL_CERT_KEY="${KONG_SSL_CERT_KEY:=spec/fixtures/kong_spec.key}"

export KONG_ADMIN_SSL_CERT="${KONG_ADMIN_SSL_CERT:=spec/fixtures/kong_spec.crt}"
export KONG_ADMIN_SSL_CERT_KEY="${KONG_ADMIN_SSL_CERT_KEY:=spec/fixtures/kong_spec.key}"

export KONG_DNS_RESOLVER="${KONG_DNS_RESOLVER:=8.8.8.8}"
export KONG_DATABASE="${KONG_DATABASE:=postgres}"
export KONG_PG_HOST="${KONG_PG_HOST:=127.0.0.1}"
export KONG_PG_PORT="${KONG_PG_PORT:=5432}"
export KONG_PG_TIMEOUT="${KONG_PG_TIMEOUT:=10000}"
export KONG_PG_DATABASE="${KONG_PG_DATABASE:=kong_tests}"
export KONG_PG_USER="${KONG_PG_USER:=kong}"
export KONG_PG_PASSWORD="${KONG_PG_PASSWORD:=kong}"
export KONG_CASSANDRA_KEYSPACE="${KONG_CASSANDRA_KEYSPACE:=kong_tests}"
export KONG_CASSANDRA_TIMEOUT="${KONG_CASSANDRA_TIMEOUT:=10000}"
export KONG_ANONYMOUS_REPORTS="${KONG_ANONYMOUS_REPORTS:=off}"

export KONG_DNS_HOSTSFILE="${KONG_DNS_HOSTSFILE:=spec/fixtures/hosts}"

export KONG_NGINX_WORKER_PROCESSES="${KONG_NGINX_WORKER_PROCESSES:=1}"
export KONG_NGINX_OPTIMIZATIONS="${KONG_NGINX_OPTIMIZATIONS:=off}"
export KONG_NGINX_USER="${KONG_NGINX_USER:=root}"

export KONG_PLUGINS="${KONG_PLUGINS:=bundled,dummy,rewriter}"

export KONG_PREFIX="${KONG_PREFIX:=servroot}"
export KONG_LOG_LEVEL="${KONG_LOG_LEVEL:=debug}"
export KONG_LUA_PACKAGE_PATH="${KONG_LUA_PACKAGE_PATH:=./spec/fixtures/custom_plugins/?.lua}"

envsubst < spec/kong_tests.conf > spec/kong_tests.conf.tmp && mv spec/kong_tests.conf.tmp spec/kong_tests.conf
bin/busted $KONG_TESTS
