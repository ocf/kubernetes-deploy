DOCKER_REPO ?=
DOCKER_REVISION ?= kubernetes-deploy-testing-$(USER)
DOCKER_TAG = $(DOCKER_REPO)kube-deploy:$(DOCKER_REVISION)
DOCKER_LATEST = $(DOCKER_REPO)kube-deploy:latest

.PHONY: cook-image
cook-image: Dockerfile deploy.sh generate-namespace.py
	docker build -t $(DOCKER_TAG) -f Dockerfile .

.PHONY: push-image
push-image:
	docker tag $(DOCKER_LATEST) $(DOCKER_TAG)
	docker push $(DOCKER_TAG)
