# Example of a SOAP  API, which redirects calls to the Azure Service Bus topic
# derived from teh REST API example


resource "azurerm_api_management_product" "apim_product_soap" {
  product_id            = "my_product_id_soap"
  api_management_name   = azurerm_api_management.app.name
  resource_group_name   = azurerm_resource_group.rg.name
  display_name          = "My ProductSoap"
  description           = "My Product Description Soap"
  terms                 = "My Product Terms"
  subscription_required = true
  subscriptions_limit   = 1
  approval_required     = true
  published             = true
}


### simple.wsdl file
locals{
  wsdl_example = <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<wsdl:definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
  xmlns:tns="http://sc.intra/AZSBAdapterService/"
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  name="AZSBAdapterService"
  targetNamespace="http://sc.intra/AZSBAdapterService/">
  <wsdl:documentation>Simple WSDL</wsdl:documentation>

  <wsdl:types>
    <xsd:schema targetNamespace="http://sc.intra/AZSBAdapterService/">
      <xsd:element name="AddMessageRequestSchema" type="xsd:string" />
      <xsd:element name="AddMessageResponseSchema" type="xsd:string" />
    </xsd:schema>
  </wsdl:types>

  <wsdl:message name="AddMessageRequest">
    <wsdl:part name="parameters" element="tns:AddMessageRequestSchema"></wsdl:part>
  </wsdl:message>
  <wsdl:message name="AddMessageResponse">
    <wsdl:part name="parameters" element="tns:AddMessageResponseSchema"></wsdl:part>
  </wsdl:message>

  <wsdl:portType name="AZSBAdapterService">
    <wsdl:operation name="AddMessage">
      <wsdl:input message="tns:AddMessageRequest"></wsdl:input>
      <wsdl:output message="tns:AddMessageResponse"></wsdl:output>
    </wsdl:operation>
  </wsdl:portType>

  <wsdl:binding name="AZSBAdapterServiceSOAP" type="tns:AZSBAdapterService">
    <soap:binding style="document"
      transport="http://schemas.xmlsoap.org/soap/http" />
    <wsdl:operation name="AddMessage">
      <soap:operation
        soapAction="http://sc.intra/AZSBAdapterService/AddMessage" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
  </wsdl:binding>

  <wsdl:service name="AZSBAdapterService">
    <wsdl:port binding="tns:AZSBAdapterServiceSOAP" name="AZSBAdapterServiceSOAP1">
      <soap:address location="http://sc.intra/AZSBAdapterService" />
    </wsdl:port>
    <wsdl:port binding="tns:AZSBAdapterServiceSOAP" name="AZSBAdapterServiceSOAP2">
      <soap:address location="http://sc.intra/AZSBAdapterService" />
    </wsdl:port>
  </wsdl:service>
</wsdl:definitions>
EOF
}

resource "azurerm_api_management_api" "apim_api_soap" {
  name                = "api-name-soap"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.app.name
  revision            = "1"
  display_name        = "Integrations of SOAP API with Azure Managed Services"
  api_type            = "http"
  path                = "soapapi"
  protocols           = ["https"]
  description           = "Example Test"
  service_url           = null
  subscription_required = false

  import {
    content_format = "wsdl"
    content_value  = local.wsdl_example

    wsdl_selector {
      service_name  = "AZSBAdapterService"
      endpoint_name = "AZSBAdapterServiceSOAP1"
    }
  }
}



# https://byalexblog.net/article/azure-apimanagement-to-azure-service-bus/
resource "azurerm_api_management_api_operation_policy" "apim_api_operation_policy_servicebus_soap" {
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
