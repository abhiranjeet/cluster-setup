# disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab

# enable bridge netfilter & iptables
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# install tools for adding apt sources
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli

# install kubernetes
# NOTE: "xenial" is correct here. Kubernetes publishes the Debian-based packages at kubernetes-xenial.
# reference: https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-using-native-package-management
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet=1.18.5-00 kubeadm=1.18.5-00 kubectl=1.18.5-00
