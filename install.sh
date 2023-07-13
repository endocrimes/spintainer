#!/usr/bin/env bash

set -euo pipefail

version="${SPIN_VERSION}"
goosArch="${TARGETARCH}"
os="${TARGETOS}"

# Check if we're on a supported system and get OS and processor architecture to download the right version
#

case $goosArch in
"amd64")
    ARC="amd64"
    ;;
"arm64" | "aarch64")
    ARC="aarch64"
    ;;
*)
    echo "The Processor type: $goosArch is not yet supported by Spin."
    exit 1
    ;;
esac

# Constructing download FILE and URL
FILE="spin-v${version}-${os}-${ARC}.tar.gz"
URL="https://github.com/fermyon/spin/releases/download/v${version}/${FILE}"

wget "$URL" \
  && tar -xzf "$FILE" \
  && ls -lahR . \
  && mv "./spin" /artifacts/spin \
  && mv "./LICENSE" /artifacts/SPIN_LICENSE
