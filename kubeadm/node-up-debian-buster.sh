#!/bin/bash
set -e;

# Set up a single-node Kubernetes system on Debian 10 (Buster).
# Use Flannel as the network fabric. Install the Kubernetes
# dashboard.

# disable swap
swapoff -a;

# enable bridge netfilter
modprobe br_netfilter;
echo 'net.bridge.bridge-nf-call-iptables = 1' > /etc/sysctl.d/20-bridge-nf.conf;
sysctl --system;

# install tools for adding apt sources
apt-get update;
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2;

# install docker
mkdir /etc/docker;
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": { "max-size": "100m" },
  "storage-driver": "overlay2"
}
EOF
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -;
echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' > /etc/apt/sources.list.d/docker.list;
apt-get update;
apt-get install -y docker-ce;

# install kubernetes
# NOTE: "xenial" is correct here. Kubernetes publishes the Debian-based packages at kubernetes-xenial.
# reference: https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-using-native-package-management
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -;
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list;
apt-get update;
apt-get install -y kubelet kubeadm kubectl;
