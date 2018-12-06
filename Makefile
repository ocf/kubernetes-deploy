DOCKER_REPO ?=
DOCKER_REVISION ?= kubernetes-deploy-testing-$(USER)
DOCKER_NAME = $(DOCKER_REPO)kube-deploy
DOCKER_TAG = $(DOCKER_NAME):$(DOCKER_REVISION)
DOCKER_LATEST = $(DOCKER_NAME):latest

.PHONY: cook-image
cook-image: Dockerfile deploy.sh generate-namespace.py
	docker build -t $(DOCKER_TAG) -f Dockerfile .

.PHONY: push-image
push-image:
	docker tag $(DOCKER_TAG) $(DOCKER_LATEST)
	docker push $(DOCKER_NAME)
