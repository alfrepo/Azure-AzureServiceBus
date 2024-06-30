# access remote state
# data "terraform_remote_state" "project_foundation" {
#     backend = "local"

#     config = {
#         path = "${path.module}/../../../project_foundation/environments/env1/terraform.tfstate"
#     }
# }

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}
