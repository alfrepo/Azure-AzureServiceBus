
set -eo pipefail

# deploy the functions now
APPNAME="app-006"


cd ./../../../../../${APPNAME}/python-publish/
export functionname="alfdevapi6-func1-pub1"
bash az_func_deploy.sh
export functionname="alfdevapi6-func1-pub2"
bash az_func_deploy.sh
cd -


cd ./../../../../../${APPNAME}/python-consume/
export functionname="alfdevapi6-func1-con1"
bash az_func_deploy.sh
export functionname="alfdevapi6-func1-con2"
bash az_func_deploy.sh
cd -
