IMAGE:=ibmosquito/dq:32.4.2
NAME:=dq

all: build run

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

