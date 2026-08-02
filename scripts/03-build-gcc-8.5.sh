#!/usr/bin/env bash
set -euo pipefail

VERSION=8.5.0
SRC=/data/gcc-${VERSION}
BUILD=/data/gcc-8.5-build
PREFIX=/data/gcc-8.5
ARCHIVE=/data/gcc-${VERSION}.tar.gz
URL=https://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.gz

sudo apt-get update
sudo apt-get install -y build-essential libgmp-dev libmpfr-dev libmpc-dev flex bison wget

cd /data
wget -c -O "$ARCHIVE" "$URL"
rm -rf "$SRC" "$BUILD"
tar -xzf "$ARCHIVE"
mkdir -p "$BUILD"
cd "$BUILD"

"$SRC/configure" \
  --prefix="$PREFIX" \
  --enable-languages=c,c++ \
  --disable-multilib \
  --disable-bootstrap

make -j1
make install

"$PREFIX/bin/gcc" --version
"$PREFIX/bin/g++" --version
