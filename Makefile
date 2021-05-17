name := postgresql-backup-s3
version := $(shell cat VERSION)
image := sverrirab/$(name)

all: echo build push

build:
	docker build -t $(name) ./docker

tag:
	docker tag $(name) $(image):$(version)
	docker tag $(name) $(image):latest

push: tag
	docker push $(image):$(version)
	docker push $(image):latest

echo:
	@echo "image:   $(image)"
	@echo "version: $(version)"
