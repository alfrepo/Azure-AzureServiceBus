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




# deploy the functions now
APPNAME="app-006"


cd ./../../../../../${APPNAME}/python-publish/
bash az_func_deploy.sh
cd -

cd ./../../../../../${APPNAME}/python-consume/
bash az_func_deploy.sh
cd -
