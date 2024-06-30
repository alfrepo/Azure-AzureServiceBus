resource "azurerm_api_management_product" "apim_product" {
  product_id            = "my_product_id"
  api_management_name   = azurerm_api_management.app.name
  resource_group_name   = azurerm_resource_group.rg.name
  display_name          = "My Product"
  description           = "My Product Description"
  terms                 = "My Product Terms"
  subscription_required = true
  subscriptions_limit   = 1
  approval_required     = true
  published             = true
}

resource "azurerm_api_management_api" "apim_api" {
  name                = "example-api-name"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  revision            = "1"
  display_name        = "Integrations with Azure Managed Services"
  api_type            = "http"
  path                = "path"
  protocols           = ["https"]

  subscription_key_parameter_names {
    header = "subscription"
    query  = "subscription"
  }
}

resource "azurerm_api_management_product_api" "apim_product_api" {
  api_name            = azurerm_api_management_api.apim_api.name
  product_id          = azurerm_api_management_product.apim_product.product_id
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
}

resource "azurerm_api_management_api_operation" "apim_api_opn" {
  operation_id        = "to-service-bus"
  api_name            = azurerm_api_management_api.apim_api.name
  api_management_name = azurerm_api_management_api.apim_api.api_management_name
  resource_group_name = azurerm_api_management_api.apim_api.resource_group_name
  display_name        = "Send data to the service bus queue"
  method              = "POST"
  url_template        = "/servicebus"
  description         = "Send data to the service bus queue"
}

## link the API Management to the Azure Service Bus. 
# First, allow the API Management to access the Azure Service Bus Topic:


# TODO fix
#  principal_id         = azurerm_api_management.app.identity.0.principal_id
# azurerm_api_management.app.identity is empty list of object
#The given key does not identify an element in this collection value: the collection has no elements

# resource "azurerm_role_assignment" "apim_role_assignment" {
#   scope                = azurerm_servicebus_namespace.sb.id
#   role_definition_name = "Azure Service Bus Data Sender"
#   principal_id         = azurerm_api_management.app.identity.0.principal_id
# }

# TODO try this code
resource "azurerm_role_assignment" "apim_role_assignment" {
  scope                =  "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}"
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_api_management.app.identity.0.principal_id
  depends_on           = [azurerm_api_management.app]
}

# tell API Management how to connect to the Azure Service Bus Topic.

resource "azurerm_api_management_named_value" "nv_sb_base_url" {
  name                = "sb-base-url"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  display_name        = "sb-base-url"
  value               = "https://${azurerm_servicebus_namespace.sb.name}.servicebus.windows.net"
}

resource "azurerm_api_management_named_value" "nv_sb_queue" {
  name                = "sb-queue_or_topic"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  display_name        = "sb-queue_or_topic"
  value               = azurerm_servicebus_topic.mtopic.name
}

# Finally, we need to create the API Management Policy that will send the message to the Azure Service Bus Topic.

# https://byalexblog.net/article/azure-apimanagement-to-azure-service-bus/
resource "azurerm_api_management_api_operation_policy" "apim_api_operation_policy_servicebus" {
  api_name            = azurerm_api_management_api_operation.apim_api_opn.api_name
  api_management_name = azurerm_api_management_api_operation.apim_api_opn.api_management_name
  resource_group_name = azurerm_api_management_api_operation.apim_api_opn.resource_group_name
  operation_id        = azurerm_api_management_api_operation.apim_api_opn.operation_id

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <authentication-managed-identity resource="https://servicebus.azure.net/" />
    <set-header name="BrokerProperties" exists-action="override">
      <value>@{  
        var json = new JObject();  
        json.Add("MessageId", context.RequestId);  
        return json.ToString(Newtonsoft.Json.Formatting.None);                      
      }</value>
    </set-header>
    <set-backend-service base-url="{{sb-base-url}}" />
    <rewrite-uri template="{{sb-queue_or_topic}}/messages" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
    <choose>
      <when condition="@(context.Response.StatusCode == 201)">
        <set-header name="Content-Type" exists-action="override">
          <value>application/json</value>
        </set-header>
        <set-body>@{  
          var json = new JObject() {{"OperationId", context.RequestId}} ;  
          return json.ToString(Newtonsoft.Json.Formatting.None);       
          }</set-body>
      </when>
    </choose>
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}

# TODO complete from
# https://byalexblog.net/article/azure-apimanagement-to-azure-service-bus/