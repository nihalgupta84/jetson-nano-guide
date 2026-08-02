# 2. Recovery from a blank or replaced Jetson Nano

This chapter is the canonical recovery sequence.

## 2.1 Prepare hardware

Use a reliable power supply and active cooling. Use at least a 32 GB microSD card; 64 GB or more is preferable. Attach secondary storage and mount it at `/data` when possible.

## 2.2 Install the supported Nano software image

Install a JetPack 4.6-generation image suitable for the original Jetson Nano. Complete first boot, create the `nvidia` user, connect networking, and enable SSH.

Do not attempt to install JetPack 5 or 6 on the original Nano.

## 2.3 Verify identity and software

```bash
cat /proc/device-tree/model
dpkg-query --show nvidia-l4t-core
head -n 1 /etc/nv_tegra_release
uname -m
lsb_release -a
/usr/local/cuda-10.2/bin/nvcc --version
```

Expected core values:

```text
NVIDIA Jetson Nano Developer Kit
L4T 32.6.1
Ubuntu 18.04
AArch64
CUDA 10.2
```

## 2.4 Inspect storage and memory

```bash
df -h
free -h
sudo tegrastats
```

Create `/data` and place all large artifacts there.

## 2.5 Execute setup scripts

Run these scripts in order:

```text
01-verify-platform.sh
02-install-cmake.sh
03-build-gcc-8.5.sh
04-clone-llama.sh
05-patch-llama-cuda10.sh
06-build-llama-cuda.sh
07-verify-llama-cuda.sh
```

## 2.6 Download and run a model

Follow `models/MODELS.md`, then use `08-run-smollm2.sh`.

## 2.7 Preserve a device backup

After confirming the system works, create an image of the microSD card and separately back up `/data/jetson-nano-guide`, model manifests, benchmark results, and configuration files. Do not rely only on the live SD card.
