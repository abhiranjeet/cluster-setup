# Setting Up a Kubernetes Cluster
Creating a kubernetes cluster on Ubuntu 18.04/20.04

## Step 1 : Command to run on every node in the cluster :
```
$ git clone https://github.com/abhiranjeet/cluster-setup.git
$ cd cluster-setup
$ chmod +x node-up.sh
$ sudo bash node-up.sh
```

## Step 2 : Command to run on your kubernetes master machine / node :
```
$ kubeadm init --apiserver-advertise-address=<ip-of-your-master-machine> --pod-network-cidr=<cni-of-your-choice> --ignore-preflight-errors=all
```

## Step 3 : Deploy All Manifests :
```
$ cd cluster-setup
$ chmod +x deployments.sh
$ sudo bash deployments.sh
```
