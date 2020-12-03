# Setting Up a Kubernetes Cluster
Creating a kubernetes cluster on Ubuntu 18.04/20.04

## Command to run on every node in the cluster :
```
$ git clone https://github.com/abhiranjeet/cluster-setup.git
$ sudo bash node-up.sh
```

## Command to run on your kubernetes master machine / node :
```
$ kubeadm init --apiserver-advertise-address=<master-node-ip-of-your-machine> --pod-network-cidr=<cni-of-your-choice>  --ignore-preflight-errors=all
```

## Using Weavenet CNI :
```
$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
