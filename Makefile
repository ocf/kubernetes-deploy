DOCKER_REPO ?=
DOCKER_REVISION ?= kubernetes-deploy-testing-$(USER)
DOCKER_NAME = $(DOCKER_REPO)kubernetes-deploy
DOCKER_TAG = $(DOCKER_NAME):$(DOCKER_REVISION)
DOCKER_LATEST = $(DOCKER_NAME):latest

.PHONY: cook-image
cook-image: Dockerfile
	docker build -t $(DOCKER_TAG) -f Dockerfile .

.PHONY: push-image
push-image:
	docker tag $(DOCKER_TAG) $(DOCKER_LATEST)
	docker push $(DOCKER_NAME)
