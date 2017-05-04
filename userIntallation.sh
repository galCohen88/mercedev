echo "Creating env dirs"
mkdir namespaces
mkdir namespaces/$USER

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

echo "Checking for entr installed"

brew ls --versions entr > /dev/null;
if [[ $? != 0 ]] ; then
    echo "Installing entr"
    brew install entr
else
    echo "entr already installed"
fi

echo "Creating new kubernetes namespace for $USER"
kubectl create namespace $USER -o yaml  > namespaces/$USER/namespace.yaml


dashboardPass="$(kubectl config view -o jsonpath='{.users[?(@.name == "devkube.cloudlockng.com")].user.password}')"
dashboardUser="$(kubectl config view -o jsonpath='{.users[?(@.name == "devkube.cloudlockng.com")].user.username}')"

kubectl cluster-info

echo "************************************************************"
echo "Dashboard user: ${dashboardUser}"
echo "Dashboard password: ${dashboardPass}"
echo "************************************************************"

