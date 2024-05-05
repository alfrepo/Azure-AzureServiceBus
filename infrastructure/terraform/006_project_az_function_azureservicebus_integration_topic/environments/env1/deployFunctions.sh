
set -eo pipefail

# deploy the functions now
APPNAME="app-006"


cd ./../../../../../${APPNAME}/python-publish/
export functionname="alfdevapi6alfdevfunction-func-pub1"
bash az_func_deploy.sh
export functionname="alfdevapi6alfdevfunction-func-pub2"
bash az_func_deploy.sh
cd -


cd ./../../../../../${APPNAME}/python-consume/
export functionname="alfdevapi6alfdevfunction-func-con1"
bash az_func_deploy.sh
export functionname="alfdevapi6alfdevfunction-func-con2"
bash az_func_deploy.sh
cd -
