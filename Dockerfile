FROM ubuntu:20.04

ARG kubectl_version=1.20.1
ARG kustomize_version=3.9.1
ARG sopsgen_version=1.3.2
ARG sops_version=3.6.1
ARG img_version=0.5.11

WORKDIR /root

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    curl \
    bridge-utils \
    ca-certificates \
    dnsutils \
    iproute2 \
    traceroute \
    iptables \
    iputils-ping \
    netcat \
    openssl \
    telnet \
    man \
    jq \
    tmux \
    vim \
    wget \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q "https://storage.googleapis.com/kubernetes-release/release/v${kubectl_version}/bin/linux/amd64/kubectl" -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
  && wget -q "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${kustomize_version}/kustomize_v${kustomize_version}_linux_amd64.tar.gz" -O /tmp/kustomize.tar.gz \
  && bash -c "cd /tmp && gunzip -c kustomize.tar.gz | tar -xvf - && mv -v /tmp/kustomize /usr/local/bin" \
  && wget -q "https://github.com/goabout/kustomize-sopssecretgenerator/releases/download/v${sopsgen_version}/SopsSecretGenerator_${sopsgen_version}_linux_amd64" -O SopsSecretGenerator \
    && chmod +x SopsSecretGenerator \
    && mkdir -p "/root/.config/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" \
    && mv SopsSecretGenerator "/root/.config/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" \
  && wget https://github.com/mozilla/sops/releases/download/v${sops_version}/sops-v${sops_version}.linux \
    && chmod +x sops-v${sops_version}.linux \
    && mv sops-v${sops_version}.linux /usr/local/bin/sops \
  && curl -fSL https://github.com/genuinetools/img/releases/download/v${img_version}/img-linux-amd64 -o /usr/local/bin/img \
    && chmod a+x /usr/local/bin/img

CMD [ "sleep", "infinity" ]
