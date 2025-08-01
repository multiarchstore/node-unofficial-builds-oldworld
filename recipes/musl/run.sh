#!/usr/bin/env bash

set -e
set -x

release_urlbase="$1"
disttype="$2"
customtag="$3"
datestring="$4"
commit="$5"
fullversion="$6"
source_url="$7"
source_urlbase="$8"
config_flags="--partly-static --openssl-no-asm"

cd /home/node

tar -xf node.tar.xz
cd "node-${fullversion}"

MAJOR_VERSION=$(echo ${fullversion} | cut -d . -f 1 | tr --delete v)
if [ "${MAJOR_VERSION}" = "18" ]; then
  # https://github.com/nodejs/node/issues/56280#issuecomment-2713336973
  curl -L https://github.com/loong64/node/raw/refs/heads/master/update-simdutf-6.2.1.patch | patch -p1
fi

export CC_host="ccache gcc-12"
export CXX_host="ccache g++-12"
export CC="ccache /opt/x-tools/loongarch64-unknown-linux-musl/bin/loongarch64-unknown-linux-musl-gcc"
export CXX="ccache /opt/x-tools/loongarch64-unknown-linux-musl/bin/loongarch64-unknown-linux-musl-g++"

make -j$(getconf _NPROCESSORS_ONLN) binary V= \
  DESTCPU="loong64" \
  ARCH="loong64" \
  VARIATION="musl" \
  DISTTYPE="$disttype" \
  CUSTOMTAG="$customtag" \
  DATESTRING="$datestring" \
  COMMIT="$commit" \
  RELEASE_URLBASE="$release_urlbase" \
  CONFIG_FLAGS="$config_flags"

mv node-*.tar.?z /out/
