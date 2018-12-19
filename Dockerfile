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

# kubernetes-deploy requires that this environment variable be set, and passes
# it to templates as the `current_sha` variable. We don't ever use it.
ENV REVISION=unused

WORKDIR /input
ENTRYPOINT ["kubernetes-deploy", "--template-dir=/input"]
