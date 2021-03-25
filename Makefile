DOCKERHUB_ID:=ibmosquito
NAME:=dq
L4T_VERSION:=32.4.2
IMAGE:=$(DOCKERHUB_ID)/dq:$(L4T_VERSION)

default: help

help:
	@echo "Try these commands:"
	@echo "    make dq"
	@echo "    make nvruntime"
	@echo "    make tegrarelease"
	@echo "    make l4tversion"

dq:
	cd /usr/local/cuda/samples/1_Utilities/deviceQuery && sudo make
	sudo cp /usr/local/cuda/samples/1_Utilities/deviceQuery/deviceQuery /usr/local/bin/dq
	dq

nvruntime:
	docker info | grep -i nvidia

tegrarelease:
	cat /etc/nv_tegra_release

l4tversion:
	dpkg-query --show nvidia-l4t-core

build:
	docker build -t $(IMAGE) -f ./Dockerfile .

dev:
	-docker rm -f $(NAME) 2>/dev/null || :
	docker run -it --name $(NAME) -v `pwd`:/outside $(IMAGE) /bin/bash

run:
	-docker rm -f $(NAME) 2>/dev/null || :
	docker run -it --name $(NAME) $(IMAGE)

push:
	docker push $(IMAGE)

