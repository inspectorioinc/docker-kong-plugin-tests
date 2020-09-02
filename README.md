# docker-kong-plugin-tests
A docker container for: 
1. running unit/integration tests of konghq plugins 
2. running kong with your custom plugin installed. 

## Uses
[busted](https://github.com/Olivine-Labs/busted) unit testing framework and konghq helpers.lua modules

## Usage
## Running tests
### As base image in Dockerfile
To use this image as your base image you should:
1. `ADD/COPY` your plugin to `/plugin/` folder
2. Point `KONG_TESTS` env variable to test location folder
#### Example
```
FROM inspectorio/kong-plugin-tests:v0.1.0-kong1.4-bionic

ADD ./my-awesome-plugin /plugin/

ENV KONG_TESTS=/plugin/tests
```

### docker run
With `docker run` command you can do the same as in base iamge approach but use `--volume/-v`, `--env/-e` arguments
#### Example 
```
docker run -v $(pwd)/my-awesome-plugin:/plugin/ \
           -e KONG_TESTS=/plugin/tests \
           inspectorio/kong-plugin-tests:bionic
```
## Running kong
To run kong with your plugin installed you need to:
1. add the plugin files and `rockpec` to `/plugin` dir inside container
2. Run `/kong/docker-entrypoint.sh` command with `run_kong` argument
### docker-compose example
```
version: '2.1'

volumes:
  kong_data:

networks:
  default:
    name:
      kong-net

services:
  kong-migrations:
    image: "${KONG_DOCKER_TAG:-kong:2.0.4}"
    container_name: kong-migrations
    command: >
      kong migrations bootstrap &&
      kong migrations up &&
      kong migrations finish
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      KONG_PG_HOST: postgres
      KONG_DATABASE: postgres
      KONG_PG_DATABASE: ${KONG_PG_DATABASE:-kong}
      KONG_PG_USER: ${KONG_PG_USER:-kong}
      KONG_PG_PASSWORD: ${KONG_PG_PASSWORD:-kong}

  postgres:
    image: postgres:9.5
    hostname: postgres
    container_name: postgres
    environment:
      POSTGRES_DB: ${KONG_PG_DATABASE:-kong}
      POSTGRES_USER: ${KONG_PG_USER:-kong}
      POSTGRES_PASSWORD: ${KONG_PG_PASSWORD:-kong}
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "kong"]
      interval: 30s
      timeout: 30s
      retries: 3
    stdin_open: true
    tty: true
    volumes:
      - kong_data:/var/lib/postgresql/data
    ports:
      - 25432:5432
      
  kong:
    image: inspectorio/kong-plugin-tests:alpine
    container_name: kong
    command: [ "/kong/docker-entrypoint.sh", "run_kong"]
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: postgres
      KONG_PG_DATABASE: kong
      KONG_PG_USER: kong
      KONG_PG_PASSWORD: kong
      KONG_ADMIN_LISTEN: 0.0.0.0:8001
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ERROR_LOG: /dev/stderr
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_PLUGINS: bundled,my-awsesome-plugin
      KONG_LOG_LEVEL: debug
    ports:
      - 8000:8000/tcp
      - 8001:8001/tcp
      - 8443:8443/tcp
      - 8444:8444/tcp
    healthcheck:
      test: ["CMD", "kong", "health"]
      interval: 10s
      timeout: 10s
      retries: 10
    depends_on:
      postgres:
        condition: service_healthy
      kong-migrations:
        condition: service_started
    volumes:
      - ./my-awsesome-plugin:/plugin
```
