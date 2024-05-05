resourceg="alfdevapi6-my-azfunc-rg"

# better use the func api. It seems to be more transparent and also packages on its own
# delete the old zip, to prevent it to be included into new zip
rm app.zip


if [[ -z "${functionname}" ]]; then
  # is undefined
  functionname="alfdevapi6alfdevfunction-func-con"
fi


# publish now
func azure functionapp publish $functionname --debug 

