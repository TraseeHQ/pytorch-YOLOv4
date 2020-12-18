DOCKER_RUN := docker run --rm -it --gpus all
LOCAL_USER := -e LOCAL_USER_ID=`id -u $(USER)` -e LOCAL_GROUP_ID=`id -g $(USER)`
tag = trasee/yolov4:latest
DOCKER_ARGS ?= -v $(shell pwd):/app --shm-size 32G

help:  ## Show this help
	@grep -E '^[.a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build docker image with all dependencies
	docker build -f dockerfiles/Dockerfile -t $(tag) .

cmd ?= /bin/bash
run:  ## Run docker shell
	$(DOCKER_RUN) $(LOCAL_USER) $(DOCKER_ARGS) $(tag) $(cmd)

convert_onnx:  ## Convert yolo model to onnx (provide yolov4.cfg and yolov4.weights in root dir)
	$(DOCKER_RUN) $(LOCAL_USER) $(DOCKER_ARGS) $(tag) python3 demo_darknet2onnx.py yolov4.cfg yolov4.weights data/giraffe.jpg 16

run_trtexec:  ## Run docker for building tensort model
	$(DOCKER_RUN) $(DOCKER_ARGS) nvcr.io/nvidia/tensorrt:20.12-py3 $(cmd)

convert_trt:  ## Convert onnx model for trtexec (provide yolov4.onnx in root dir)
	$(DOCKER_RUN) $(DOCKER_ARGS) nvcr.io/nvidia/tensorrt:20.12-py3 trtexec --onnx=yolov4.onnx --explicitBatch --shapes=input:16x3x416x416 --minShapes=input:1x3x416x416 --optShapes=input:4x3x416x416 --maxShapes=input:16x3x416x416 --workspace=4096 --saveEngine=yolo.engine --fp16
