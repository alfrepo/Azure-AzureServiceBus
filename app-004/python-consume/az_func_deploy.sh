prefix="alfdevapi4"
functionname="${prefix}alfdevfunction-func-con"
resourceg="${prefix}-my-azfunc-rg"


az functionapp deployment source config-zip -g $resourceg -n $functionname --src app.zip


#9. Test the basic function at https://dsdurablefunctions.azurewebsites.net/api/reply.

#10. Test the orchestrator function at https://dsdurablefunctions.azurewebsites.net/api/orchestrators/orchestrator.