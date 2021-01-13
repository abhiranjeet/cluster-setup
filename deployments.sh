echo "Downloading Prerequisites................................................................................................................................................."
echo "Installing Helm v3........................................................................................................................................................"
sudo snap install helm --classic

echo "Installing crictl Tools..................................................................................................................................................."
VERSION="v1.18.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin

echo "Installing critest Tools.................................................................................................................................................."
VERSION="v1.18.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/critest-$VERSION-linux-amd64.tar.gz
sudo tar zxvf critest-$VERSION-linux-amd64.tar.gz -C /usr/local/bin

echo "TASK 1....Deploying WeaveNet CNI"
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
echo "TASK 1....In Progress"
echo "TASK 1....In Progress"
echo "TASK 1....In Progress"
echo "TASK 1....In Progress"
echo "TASK 1....In Progress"
echo "TASK 1....In Progress"
echo "TASK 1....CNI Deployed"

echo "TASK 2....Deploying OLM"
export olm_release=0.15.1
kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${olm_release}/crds.yaml
echo "TASK 2....In Progress"
echo "TASK 2....In Progress"
echo "TASK 2....In Progress"
echo "TASK 2....In Progress"
echo "TASK 2....In Progress"
echo "TASK 2....In Progress"
kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${olm_release}/olm.yaml
echo "TASK 2....OLM Deployed"

echo "TASK 3....Deploying KubeVirt"
export VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases | grep tag_name | grep -v -- '-rc' | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)
echo $VERSION
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml
echo "TASK 3....In Progress"
echo "TASK 3....In Progress"
echo "TASK 3....In Progress"
echo "TASK 3....In Progress"
echo "TASK 3....In Progress"
echo "TASK 3....In Progress"
echo "TASK 3....In Progress"
echo "TASK 3....KubeVirt Deployed"

echo "TASK 4....Deploying Virtctl"
export VERSION=v0.26.1
curl -L -o virtctl https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-x86_64
chmod +x virtctl
sudo install virtctl /usr/local/bin
echo "TASK 4....Virtctl Deployed"

echo "TASK 5....Installing CDI Operator for KubeVirt"
export VERSION=$(curl -s https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -o "v[0-9]\.[0-9]*\.[0-9]*")
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml
echo "TASK 5....Done"

echo "TASK 6....Its time for CNI-Genie"
curl https://docs.projectcalico.org/manifests/canal.yaml -O
kubectl apply -f canal.yaml
git clone https://github.com/cni-genie/CNI-Genie.git
kubectl apply -f https://raw.githubusercontent.com/cni-genie/CNI-Genie/master/conf/1.8/genie-plugin.yaml
helm repo add linkerd2 https://helm.linkerd.io/stable
helm install my-linkerd2-cni linkerd2/linkerd2-cni --version 2.9.0
echo "TASK 6....Installing Multiple CNIs"

echo "TASK 7....Installing NSM Components"
helm repo add nsm https://helm.nsm.dev/
helm repo update
helm install nsm nsm/nsm
git clone https://github.com/PANTHEONtech/cnf-examples.git
echo "TASK 7....Done"

echo "TASK 8....Installing WeaveScope"
kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
echo "TASK 8....WeaveScope Done"

echo "TASK 9....Installing Skydive Analyzer"
kubectl apply -f https://raw.githubusercontent.com/skydive-project/skydive/master/contrib/kubernetes/skydive.yaml
echo "TASK 9....Skydive Done"
