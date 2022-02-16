#!/bin/bash


set -e
git init
git clone https://github.com/nationalarchives/da-transform-terraform-modules.git
pwd
cd ./git
ls
bash <(curl -s https://raw.githubusercontent.com/nationalarchives/da-transform-terraform-modules/test_branch/terratest.sh)