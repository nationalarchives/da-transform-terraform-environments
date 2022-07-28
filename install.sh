#!/bin/bash

echo "Installing Terraform"
yum -q -y install sudo
wget https://releases.hashicorp.com/terraform/1.0.10/terraform_1.0.10_linux_amd64.zip
unzip terraform_1.0.10_linux_amd64.zip
sudo mv terraform /bin
rm terraform_1.0.10_linux_amd64.zip
terraform --version
echo "Install tfsec"
curl -Lso tfsec https://github.com/aquasecurity/tfsec/releases/download/v1.4.2/tfsec-linux-amd64
chmod +x tfsec
sudo mv tfsec /usr/local/bin/tfsec