This repo "packages" Shopify's [`kubernetes-deploy`](https://github.com/Shopify/kubernetes-deploy) as a Docker image. This image shouldn't be called on its own. Instead, it should be called by the `ocf-kubernetes-deploy` in `utils`.

The image takes the following as inputs:
* Volume: `/input`: the directory which holds Kubernetes resource files or templates.
* Volume: `/kubeconfig`: the `KUBECONFIG` file to use. Note that this should be a file, not a directory.
