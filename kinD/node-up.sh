echo "TASK 1....Downloading Docker"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
echo "TASK 1....Done"

echo "TASK 2....Downloading GoLang Tools"
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
tar zxf go1.15.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "TASK 2....Done"

echo "TASK 3....Setting up cluster using kinD"
GO111MODULE="on" go get sigs.k8s.io/kind@v0.9.0
export PATH=$PATH:~/go/bin
kind create cluster
echo "TASK 4....Done"
