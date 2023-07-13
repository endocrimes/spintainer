# syntax=docker/dockerfile:1
FROM --platform=${BUILDPLATFORM} debian:bookworm-slim as downloader
ARG SPIN_VERSION
ARG TARGETARCH TARGETOS

RUN mkdir /artifacts

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home

COPY install.sh .

RUN chmod +x ./install.sh && SPIN_VERSION="${SPIN_VERSION}" ./install.sh

FROM --platform=${TARGETPLATFORM} debian:bookworm-slim

LABEL org.opencontainers.image.source=https://github.com/endocrimes/spintainer
LABEL org.opencontainers.image.description="A container for running Fermyon Spin"
LABEL org.opencontainers.image.licenses=Apache-2.0

RUN  apt-get update \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

COPY --from=downloader /artifacts/spin /usr/bin/spin
COPY --from=downloader /artifacts/SPIN_LICENSE /SPIN_LICENSE

RUN spin templates install --git "https://github.com/fermyon/spin" --upgrade \
  && spin templates install --git "https://github.com/fermyon/spin-python-sdk" --upgrade \
  && spin templates install --git "https://github.com/fermyon/spin-js-sdk" --upgrade \
  && spin plugins update \
  && spin plugins install js2wasm --yes \
  && spin plugins install py2wasm --yes \
  && spin plugins install cloud --yes

ENTRYPOINT /bin/spin
