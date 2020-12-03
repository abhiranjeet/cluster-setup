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
