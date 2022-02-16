#!/bin/bash


set -e
cd ../
pwd
git init
git clone https://github.com/nationalarchives/da-transform-terraform-modules.git
pwd

ls
cd src
bash <(curl -s https://raw.githubusercontent.com/nationalarchives/da-transform-terraform-modules/test_branch/terratest.sh)