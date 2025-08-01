FROM ubuntu:22.04

ARG GID=1000
ARG UID=1000

RUN addgroup --gid $GID node \
    && adduser --gid $GID --uid $UID --disabled-password --gecos node node

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get update \
    && apt-get install -y \
         git \
         g++-12 \
         curl \
         make \
         python3 \
         python3-distutils \
         ccache \
         xz-utils

RUN mkdir -p /opt/x-tools \
    && curl -L https://github.com/loong64/cross-tools/releases/download/20250801/x86_64-cross-tools-loongarch64-unknown-linux-gnu-stable.tar.xz | tar xJf - -C /opt/x-tools

COPY --chown=node:node run.sh /home/node/run.sh

VOLUME /home/node/.ccache
VOLUME /out
VOLUME /home/node/node.tar.xz

USER node

ENTRYPOINT [ "/home/node/run.sh" ]
