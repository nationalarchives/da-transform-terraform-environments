#!/bin/bash

yum -qy install sudo
wget https://releases.hashicorp.com/terraform/1.0.10/terraform_1.0.10_linux_amd64.zip
unzip terraform_1.0.10_linux_amd64.zip
sudo mv terraform /bin
rm terraform_1.0.10_linux_amd64.zip
