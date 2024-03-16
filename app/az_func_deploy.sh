functionname="alfdevfunction1-func"
storage="alfdevpr1storaccazfunc1"
resourceg="alfdevpr1-my-azfunc1-rg"
location="switzerlandnorth"
functionapp_runtime="linux"

az functionapp create --resource-group $resourceg /
 --consumption-plan-location $location /
 --name $functionname /
 --storage-account $storage /
 --runtime $functionapp_runtime



az functionapp deployment source config-zip -g $resourceg -n $functionname --src app.zip


#9. Test the basic function at https://dsdurablefunctions.azurewebsites.net/api/reply.

#10. Test the orchestrator function at https://dsdurablefunctions.azurewebsites.net/api/orchestrators/orchestrator.