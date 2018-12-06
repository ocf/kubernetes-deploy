FROM docker.ocf.berkeley.edu/theocf/debian:stretch

ENV KUBERNETES_VERSION="v1.13.0"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends build-essential python3 ruby ruby-dev \
	&& gem install kubernetes-deploy

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

COPY deploy.py /usr/local/bin

volume /kubeconfig
volume /input

ENV KUBECONFIG=/kubeconfig
WORKDIR /input
ENTRYPOINT ["deploy.py"]
