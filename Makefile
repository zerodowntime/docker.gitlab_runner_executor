##
##  authors 
##  Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##  Wojciech Polnik <wojciech.polnik@zerodowntime.pl>
##

# VERSIONS += 2.4.2 
# VERSIONS += 2.5.15 
# VERSIONS += 2.6.14 2.6.16 
# VERSIONS += 2.7.0 2.7.1 2.7.2 2.7.3 2.7.4 2.7.5 2.7.6 2.7.7 2.7.8 2.7.9 2.7.10 
VERSIONS += 2.8.0

ANSIBLE_VERSION ?= $(lastword $(VERSIONS))
MOLECULE_VERSION ?= 2.20.0

IMAGE_NAME ?= zerodowntime/gitlab_runner_executor_molecule
IMAGE_TAG  ?= ansible-${ANSIBLE_VERSION}

build: Dockerfile
	docker build -t ${IMAGE_NAME}:${IMAGE_TAG} \
		--build-arg ANSIBLE_VERSION=${ANSIBLE_VERSION} \
		--build-arg MOLECULE_VERSION=${MOLECULE_VERSION} \
		.

push: build
	docker push ${IMAGE_NAME}:${IMAGE_TAG}

clean:
	docker image rm ${IMAGE_NAME}:${IMAGE_TAG}

runit: build
	docker run -it --rm ${IMAGE_NAME}:${IMAGE_TAG}

inspect: build
	docker image inspect ${IMAGE_NAME}:${IMAGE_TAG}

## Here be dragons.

push-all:
push-all:
	$(foreach VER, $(VERSIONS), $(MAKE) push-ver ANSIBLE_VERSION=$(VER); \
	)

push-ver:
	$(MAKE) push # vanilla
	$(MAKE) push MOLECULE_VERSION=2.20 IMAGE_TAG=ansible-${ANSIBLE_VERSION}-molecule-${MOLECULE_VERSION}
