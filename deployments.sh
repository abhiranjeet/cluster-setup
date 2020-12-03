echo "Downloading Prerequisites"
snap install helm --classic
echo "Proceed....Done"

echo "TASK 1....Deploying WeaveNet CNI"
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
echo "TASK 1....CNI Deployed"

echo "TASK 2....Deploying OLM"
export olm_release=0.15.1
kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${olm_release}/crds.yaml
kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${olm_release}/olm.yaml
echo "TASK 2....OLM Deployed"

echo "TASK 3....Deploying KubeVirt"
export VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases | grep tag_name | grep -v -- '-rc' | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)
echo $VERSION
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml
echo "TASK 3....KubeVirt Deployed"

#echo "TASK 4....Deploying Virtctl"
#VERSION=$(kubectl get kubevirt.kubevirt.io/kubevirt -n kubevirt -o=jsonpath="{.status.observedKubeVirtVersion}")
#ARCH=$(uname -s | tr A-Z a-z)-$(uname -m | sed 's/x86_64/amd64/') || windows-amd64.exe
#echo ${ARCH}
#curl -L -o virtctl https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-${ARCH}
#chmod +x virtctl
#install virtctl /usr/local/bin
#echo "TASK 4....Virtctl Deployed"

echo "TASK 5....Its time for CNI-Genie"
curl https://docs.projectcalico.org/manifests/canal.yaml -O
kubectl apply -f canal.yaml
git clone https://github.com/cni-genie/CNI-Genie.git
kubectl apply -f https://raw.githubusercontent.com/cni-genie/CNI-Genie/master/conf/1.8/genie-plugin.yaml
helm repo add linkerd2 https://helm.linkerd.io/stable
helm install my-linkerd2-cni linkerd2/linkerd2-cni --version 2.9.0
echo "TASK 5....Installing Multiple CNIs"
