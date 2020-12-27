apt-get update

echo "TASK 1....Disabling Firewall"
sudo ufw allow 6443/tcp
sudo ufw allow 2379/tcp
sudo ufw allow 2380/tcp
sudo ufw allow 10250/tcp
sudo ufw allow 10251/tcp
sudo ufw allow 10252/tcp
sudo ufw allow 10255/tcp
sudo ufw reload
echo "TASK 1....Done"

echo "TASK 2....Disabling Swap"
swapoff -a
sed -i '/swap/d' /etc/fstab
echo "TASK 2....Done"

echo "TASK 3....Updating IP Tables"
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy
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

echo "TASK 7....Installing Rancher"
docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher rancher/rancher:latest
echo "TASK 7....Rancher Installed"
