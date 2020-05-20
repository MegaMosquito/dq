all: build run

build:
	docker build -t ibmosquito/dq:1.0.0 -f ./Dockerfile .

dev:
	-docker rm -f dq 2>/dev/null || :
	docker run -it --name dq -v `pwd`:/outside ibmosquito/dq:1.0.0 /bin/bash

run:
	-docker rm -f dq 2>/dev/null || :
	docker run -it --name dq ibmosquito/dq:1.0.0

push:
	docker push ibmosquito/dq:1.0.0

