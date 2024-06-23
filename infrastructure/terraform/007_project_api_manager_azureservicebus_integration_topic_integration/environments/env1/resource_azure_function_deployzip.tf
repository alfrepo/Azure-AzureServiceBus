# create or UPDATE the zips with Azure functions
# which gonna be referenced from functions and deployed upon terraform deploy

data "archive_file" "function_pub_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../../../app-005/python-publish/"
  output_path = "${path.module}/../../../../../app-005/python-publish/app.zip"

  # unfortunately wildcards do not work here, without terraform functions
  excludes    = ["app.zip", "az_func_package-as-zip.sh", "az_func_deploy.sh"]

#  depends_on = [null_resource.pip]
}

data "archive_file" "function_con_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../../../app-005/python-consume/"
  output_path = "${path.module}/../../../../../app-005/python-consume/app.zip"

  # unfortunately wildcards do not work here, without terraform functions
  excludes    = ["app.zip", "az_func_package-as-zip.sh", "az_func_deploy.sh"]

#  depends_on = [null_resource.pip]
}


