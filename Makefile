DOCKER_RUN := docker run --rm -it --gpus all
LOCAL_USER := -e LOCAL_USER_ID=`id -u $(USER)` -e LOCAL_GROUP_ID=`id -g $(USER)`
tag = trasee/yolov4:latest
DOCKER_ARGS ?= -v $(shell pwd):/app

help:  ## Show this help
	@grep -E '^[.a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build docker image with all dependencies
	docker build -f dockerfiles/Dockerfile -t $(tag) .

cmd ?= /bin/bash
run:  ## Run docker shell
	$(DOCKER_RUN) $(LOCAL_USER) $(DOCKER_ARGS) $(tag) $(cmd)
