#!/usr/bin/env bash
set -euo pipefail

echo '== Device =='
tr -d '\0' < /proc/device-tree/model; echo

echo '== L4T =='
dpkg-query --show nvidia-l4t-core || true
head -n 1 /etc/nv_tegra_release || true

echo '== OS =='
uname -m
lsb_release -a || true

echo '== CUDA =='
/usr/local/cuda-10.2/bin/nvcc --version

echo '== Memory and storage =='
free -h
df -h /
df -h /data || true

echo '== GPU/thermal snapshot =='
timeout 3 sudo tegrastats || true
