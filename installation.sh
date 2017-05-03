echo "Creating env dirs"
mkdir $USER

echo "Checking for Terraform installed"
brew ls --versions terraform > /dev/null;
if [[ $? != 0 ]] ; then
    echo "Installing Terraform"
    brew install terraform
else
    echo "Terraform already installed"
fi

echo "Checking for kops installed"
brew ls --versions kops > /dev/null;
if [[ $? != 0 ]] ; then
    echo "Installing kops"
    brew install kops
else
    echo "Kops already installed"
fi

echo "Checking for kubectl installed"
brew ls --versions kubectl > /dev/null;
if [[ $? != 0 ]] ; then
    echo "Installing kubectl"
    brew install kubectl
else
    echo "kubectl already installed"
fi

echo "Creating remote dashboard"
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard-no-rbac.yaml

