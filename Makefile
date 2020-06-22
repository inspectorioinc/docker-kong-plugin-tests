VERSION_FILE = VERSION

VERSION = $(shell cat $(VERSION_FILE) 2> /dev/null)

ifeq ($(VERSION),)
$(error VERSION is not set)
endif


DOCKER_REPOSITORY = inspectorio
CONTAINER_NAME = kong-plugin-tests

.PHONY: build build_ubuntu

build: build_ubuntu


build_ubuntu:
	cd ubuntu && docker build -f Dockerfile -t $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION) .
	docker push $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION)
