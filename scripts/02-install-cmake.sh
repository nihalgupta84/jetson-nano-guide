#!/usr/bin/env bash
set -euo pipefail

VERSION=3.22.6
PREFIX=/data/cmake-${VERSION}
ARCHIVE=/data/cmake-${VERSION}-linux-aarch64.tar.gz
URL=https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}-linux-aarch64.tar.gz

mkdir -p /data
cd /data
wget -c -O "$ARCHIVE" "$URL"
rm -rf "$PREFIX"
tar -xzf "$ARCHIVE"
mv "cmake-${VERSION}-linux-aarch64" "$PREFIX"

"$PREFIX/bin/cmake" --version

echo "Add this to the required user's shell profile:"
echo "export PATH=$PREFIX/bin:\$PATH"
