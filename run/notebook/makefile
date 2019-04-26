build:
	docker build -t notebook_docker .
run:
	docker run -it -p 8888:8888 notebook_docker
run_interact:
	docker run -it -p 8888:8888 -v /Users/ktaletsk/jupyterlab-git/:/jupyterlab-git/  notebook_docker /bin/bash
start:
	docker start notebook_docker
stop:
	docker stop notebook_docker
rm:
	docker rm notebook_docker

