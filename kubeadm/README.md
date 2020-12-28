# Setting Up a Kubernetes Cluster
Creating a kubernetes cluster on Ubuntu 18.04/20.04

## Step 1 : Command to run on every node in the cluster :
```
$ git clone https://github.com/abhiranjeet/cluster-setup.git
$ cd /cluster-setup/kubeadm
```
#### Option 1 : Using Docker as container runtime
```
$ chmod +x node-up.sh
$ sudo bash node-up.sh
```

#### Option 2 : Using container-d as container runtime
```
$ chmod +x node-up.sh
$ sudo bash node-up.sh
```

#### Option 3 : Using runc as container runtime
```
$ chmod +x node-up.sh
$ sudo bash node-up.sh
```

## Step 2 : Initialize your cluster on your master node / VM :
```
$ kubeadm init --apiserver-advertise-address=<ip-of-your-master-machine> --pod-network-cidr=<cni-of-your-choice> --ignore-preflight-errors=all
```
