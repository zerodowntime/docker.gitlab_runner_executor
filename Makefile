##
##  authors 
##  Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##  Wojciech Polnik <wojciech.polnik@zerodowntime.pl>
##

# VERSIONS += 2.4.2 
# VERSIONS += 2.5.15 
VERSIONS += 2.6.0 2.6
VERSIONS += 2.7.0 2.7
VERSIONS += 2.8.0 2.8

ANSIBLE_VERSION ?= $(lastword $(VERSIONS))
MOLECULE_VERSION ?= 2.22.0

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
	$(MAKE) push MOLECULE_VERSION=${MOLECULE_VERSION} IMAGE_TAG=ansible-${ANSIBLE_VERSION}-molecule-${MOLECULE_VERSION}
