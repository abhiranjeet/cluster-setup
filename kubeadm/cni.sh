kubectl apply -f https://raw.githubusercontent.com/vmware-tanzu/antrea/main/build/yamls/antrea.yml
git clone https://github.com/intel/multus-cni.git
cd multus-cni
cat ./images/multus-daemonset.yml | kubectl apply -f -
