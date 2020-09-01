ifeq ($(VERSION),)
$(error VERSION is not set)
endif

DOCKER_REPOSITORY = inspectorio
CONTAINER_NAME = kong-plugin-tests

.PHONY: build build_ubunt build_alpine

build: build_ubuntu


build_ubuntu:
	cd ubuntu && docker build -f Dockerfile -t $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION) .
	docker push $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION)

build_alpine:
	cd alpine && docker build -f Dockerfile -t $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION) .
	docker push $(DOCKER_REPOSITORY)/$(CONTAINER_NAME):$(VERSION)
