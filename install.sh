#!/bin/bash

echo "Installing Terraform"
yum -q -y install sudo
wget https://releases.hashicorp.com/terraform/1.0.10/terraform_1.0.10_linux_amd64.zip
unzip terraform_1.0.10_linux_amd64.zip
sudo mv terraform /bin
rm terraform_1.0.10_linux_amd64.zip
terraform --version
echo "Installing Terratest Log Parser"
curl --location --silent --fail --show-error -o terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.13.13/terratest_log_parser_linux_amd64
chmod +x terratest_log_parser
mv terratest_log_parser /usr/local/bin
terratest_log_parser --version
go version
