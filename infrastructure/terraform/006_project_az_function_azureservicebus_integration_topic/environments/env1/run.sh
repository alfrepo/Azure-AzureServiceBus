#!/bin/bash
set -eo pipefail

export TF_LOG="DEBUG"
export TF_LOG_PATH="./terraform.log"
 
if [[ ! -d ".terraform" ]]
then
  terraform init
fi
 
terraform validate
terraform plan -out="PLAN.TERRAFORM"
 
terraform apply "PLAN.TERRAFORM"