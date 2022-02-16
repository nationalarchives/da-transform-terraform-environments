#!/bin/bash


set -e
cd ../
pwd
git init
git clone https://github.com/nationalarchives/da-transform-terraform-modules.git
pwd

cd da-transform-terraform-modules
ls
git branch
git checkout test_branch
./terratest.sh
# cd ../src
# bash <(curl -s https://raw.githubusercontent.com/nationalarchives/da-transform-terraform-modules/test_branch/terratest.sh)

cd test/reports/hello_world
ls
cat hello_world_test_output.log



exit