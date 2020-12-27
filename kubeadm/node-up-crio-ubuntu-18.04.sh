apt-get update

echo "TASK 1....Disabling Firewall"
ufw disable
echo "TASK 1....Done"

echo "TASK 2....Disabling Swap"
swapoff -a
sed -i '/swap/d' /etc/fstab
echo "TASK 2....Done"

echo "TASK 3....Adding Sysctl Settings"
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
echo "TASK 3....Done"

echo "TASK 4....Installing Docker Engine"
OS=xUbuntu_18.04

VERSION=1.18:1.18.5

cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers-cri-o.gpg add -

sudo apt-get update
sudo apt-get install cri-o cri-o-runc
sudo systemctl daemon-reload
sudo systemctl start crio
echo "TASK 4....Done"

echo "TASK 5....Adding Kubernetes Repository"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
echo "TASK 5....Done"

echo "TASK 6....Installing Kubernetes v1.18"
apt update && apt install -y kubeadm=1.18.5-00 kubelet=1.18.5-00 kubectl=1.18.5-00
echo "TASK 6....Done"

echo "TASK 7....Installing Rancher"
docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher rancher/rancher:latest
echo "TASK 7....Rancher Installed"
