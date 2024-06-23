
set -eo pipefail

# deploy the functions now
APPNAME="app-007"


cd ./../../../../../${APPNAME}/python-publish/
export functionname="alfdevapi7-func1-pub1"
bash az_func_deploy.sh
export functionname="alfdevapi7-func1-pub2"
bash az_func_deploy.sh
cd -


cd ./../../../../../${APPNAME}/python-consume/
export functionname="alfdevapi7-func1-con1"
bash az_func_deploy.sh
export functionname="alfdevapi7-func1-con2"
bash az_func_deploy.sh
cd -
