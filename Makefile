name := postgresql-backup-s3
version := $(shell cat VERSION)
image := sverrirab/$(name)

.PHONY: all build run tag push echo

all: echo build push

build:
	docker build --platform linux/amd64 -t $(name) ./docker

run: build
	docker run --platform linux/amd64 --rm -it --entrypoint /bin/bash $(name)

tag:
	docker tag $(name) $(image):$(version)
	docker tag $(name) $(image):latest

push: tag
	docker push $(image):$(version)
	docker push $(image):latest

echo:
	@echo "image:   $(image)"
	@echo "version: $(version)"
