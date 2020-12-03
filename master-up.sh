apt-get update

echo "TASK 1....Disabling Firewall"
ufw disable
echo "TASK 1....Done"

echo "TASK 2....Disabling Swap"
swapoff -a
sed -i '/swap/d' /etc/fstab
echo "TASK 2....Done"

echo "TASK 3....Adding Sysctl Settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
echo "TASK 3....Done"

echo "TASK 4....Installing Docker Engine"
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce containerd.io
echo "TASK 4....Done"

echo "TASK 5....Adding Kubernetes Repository"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
echo "TASK 5....Done"

echo "TASK 6....Installing Kubernetes v1.18"
apt update && apt install -y kubeadm=1.18.5-00 kubelet=1.18.5-00 kubectl=1.18.5-00
echo "TASK 6....Done"
