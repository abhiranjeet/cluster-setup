sudo apt install figlet

figlet "PODMAN - The Hero"
sudo apt-get -y update
# Debian 10
# Use buster-backports on Debian 10 for a newer libseccomp2
echo 'deb http://deb.debian.org/debian buster-backports main' >> /etc/apt/sources.list
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/Release.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y -t buster-backports install libseccomp2
sudo apt-get -y install podman

echo "Podman has been installed on your Debian 10 Machine"

#figlet "runc - OCI Compliant"
#git clone https://github.com/opencontainers/runc.git $GOPATH/src/github.com/opencontainers/runc
#cd $GOPATH/src/github.com/opencontainers/runc
#make BUILDTAGS="selinux seccomp"
#sudo cp runc /usr/bin/runc

figlet "Buildah - The Sidekick"
echo "Installing Buildah"
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/Release.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install buildah

echo "Buildah has been installed on your Debian 10 machine"
