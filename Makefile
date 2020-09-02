ifeq ($(VERSION),)
$(error VERSION is not set)
endif

ifeq ($(GEOIP_LICENSE_KEY),)
$(error GEOIP_LICENSE_KEY is not set)
endif

DOCKER_REPOSITORY = inspectorio
CONTAINER_NAME = kong-plugin-tests

.PHONY: build build_ubuntu build_alpine

build: build_ubuntu


build_ubuntu:
	cd ubuntu && docker build --build-arg GEOIP_LICENSE_KEY=$(GEOIP_LICENSE_KEY) -f Dockerfile -t $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION) .
	docker push $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION)

build_alpine:
	cd alpine && docker build --build-arg GEOIP_LICENSE_KEY=$(GEOIP_LICENSE_KEY) -f Dockerfile -t $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION) .
	docker push $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION)
