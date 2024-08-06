
set -eo pipefail

# deploy the functions now
APPNAME="app-007"


cd ./../../../../../${APPNAME}/python-publish/
export functionname="alfdevapi7sc-func1-pub1"
bash az_func_deploy.sh

cd -


cd ./../../../../../${APPNAME}/python-consume/
export functionname="alfdevapi7sc-func1-con1"
bash az_func_deploy.sh

cd -
