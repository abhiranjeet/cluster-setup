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

## Step 3 : Choose your CNI :
### Using Flannel CNI
```
$ kubeadm init --apiserver-advertise-address=<ip-of-your-master-machine> --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all
```

### Using ContiVPP CNI
```
$ kubeadm init --apiserver-advertise-address=<ip-of-your-master-machine> --pod-network-cidr=10.0.0.0/8 --ignore-preflight-errors=all
$ kubectl apply -f https://raw.githubusercontent.com/contiv/vpp/master/k8s/contiv-vpp.yaml
```

### On all nodes (for ContiVPP CNI)
```
$ sudo sysctl -w vm.nr_hugepages=512
$ service kubelet restart
```

## Step 4 : Deploy All Manifests :
```
$ cd cluster-setup
$ chmod +x deployments.sh
$ sudo bash deployments.sh
```
