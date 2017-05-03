echo "Checking for Terraform installed"

terraform --version | grep ${TERRAFORM_VERSION}
if [[ $? != 0 ]] ; then
    # Install terraform
    brew install terraform
    brew switch terraform ${TERRAFORM_VERSION}
fi

