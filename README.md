# docker-kong-plugin-tests
A docker container for running unit/integration tests for konghq plugins. 

## Uses
[busted](https://github.com/Olivine-Labs/busted) unit testing framework and konghq helpers.lua modules

## Usage

### As base image in Dockerfile
To use this image as your base image you should:
1. `ADD/COPY` your plugin to `/kong/kong/plugins/` folder
2. `ADD/COPY` your tests and point `KONG_TESTS` env variable to there location
#### Example
```
FROM inspectorio/kong-plugin-tests:v0.1.0-kong1.4-bionic

ADD ./my-awesome-plugin /kong/kong/plugins/my-awesome-plugin
ADD ./unit-tests /tests

ENV KONG_TESTS=/tests
```

### docker run
With `docker run` command you can do the same as in base iamge approach but use `--volume/-v`, `--env/-e` arguments
#### Example 
```
docker run -v $(pwd)/my-awesome-plugin:/kong/kong/plugins/my-awesome-plugin \
           -v $(pwd)/unit-tests:/tests \
           -e KONG_TESTS=/tests \
           inspectorio/kong-plugin-tests:bionic
```
