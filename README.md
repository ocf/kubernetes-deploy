This repo builds the Docker image for deploying Kubernetes apps. The docker image will mainly be run from Jenkins pipelines.

It takes the following as inputs:
* Volume: `/input`: the directory which holds Kubernetes resource files or templates
* Volume: `/kubeconfig`: the `KUBECONFIG` file to use
* Environment variable: `$REVISION`: the git commit SHA being deployed
* Command line arguments: `appname` `version` (where `version` is the docker tag to use)
