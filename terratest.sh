#!/bin/bash


set -e

bash <(curl -s https://raw.githubusercontent.com/nationalarchives/da-transform-terraform-modules/test_branch/terratest.sh)