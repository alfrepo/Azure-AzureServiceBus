# resource "azurerm_api_management_product" "apim_product2" {
#   product_id            = "my_product_id2"
#   api_management_name   = azurerm_api_management.app.name
#   resource_group_name   = azurerm_resource_group.rg.name
#   display_name          = "My Product2"
#   description           = "My Product Description"
#   terms                 = "My Product Terms"
#   subscription_required = true
#   subscriptions_limit   = 1
#   approval_required     = true
#   published             = true
# }

# resource "azurerm_api_management_api" "apim_api" {
#   name                = "example-api-name"
#   resource_group_name = azurerm_resource_group.rg.name
#   api_management_name = azurerm_api_management.app.name
#   revision            = "1"
#   display_name        = "Integrations of SOAP API with Azure Managed Services"
#   api_type            = "http"
#   path                = "soapapi"
#   protocols           = ["https"]
#   description           = "Example Test"
#   service_url           = null
#   subscription_required = false

#   import {
#     content_format = "wsdl"
#     content_value  = local.wsdl_example

#     wsdl_selector {
#       service_name  = "BookService"
#       endpoint_name = "BookServiceSOAP1"
#     }
#   }
# }

# ### simple.wsdl file
# locals{
#   wsdl_example = <<EOF
# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <wsdl:definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
#   xmlns:tns="http://www.cleverbuilder.com/BookService/"
#   xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
#   xmlns:xsd="http://www.w3.org/2001/XMLSchema"
#   name="BookService"
#   targetNamespace="http://www.cleverbuilder.com/BookService/">
#   <wsdl:documentation>Simple WSDL</wsdl:documentation>

#   <wsdl:types>
#     <xsd:schema targetNamespace="http://www.cleverbuilder.com/BookService/">
#       <xsd:element name="Book">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element name="ID" type="xsd:string" minOccurs="0" />
#             <xsd:element name="Title" type="xsd:string" />
#             <xsd:element name="Author" type="xsd:string" />
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>
#       <xsd:element name="Books">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element ref="tns:Book" minOccurs="0" maxOccurs="unbounded" />
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>

#       <xsd:element name="GetBook">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element name="ID" type="xsd:string" />
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>
#       <xsd:element name="GetBookResponse">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element ref="tns:Book" minOccurs="0" maxOccurs="1" />
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>

#       <xsd:element name="AddBook">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element ref="tns:Book" minOccurs="1" maxOccurs="1" />
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>
#       <xsd:element name="AddBookResponse">
#         <xsd:complexType>
#           <xsd:sequence>
#             <xsd:element ref="tns:Book" minOccurs="0" maxOccurs="1" />
#           </xsd:sequence>
#         </xsd:complexType>
#       </xsd:element>
#     </xsd:schema>
#   </wsdl:types>

#   <wsdl:message name="GetBookRequest">
#     <wsdl:part element="tns:GetBook" name="parameters" />
#   </wsdl:message>
#   <wsdl:message name="GetBookResponse">
#     <wsdl:part element="tns:GetBookResponse" name="parameters" />
#   </wsdl:message>
#   <wsdl:message name="AddBookRequest">
#     <wsdl:part name="parameters" element="tns:AddBook"></wsdl:part>
#   </wsdl:message>
#   <wsdl:message name="AddBookResponse">
#     <wsdl:part name="parameters" element="tns:AddBookResponse"></wsdl:part>
#   </wsdl:message>

#   <wsdl:portType name="BookService">
#     <wsdl:operation name="GetBook">
#       <wsdl:input message="tns:GetBookRequest" />
#       <wsdl:output message="tns:GetBookResponse" />
#     </wsdl:operation>
#     <wsdl:operation name="AddBook">
#       <wsdl:input message="tns:AddBookRequest"></wsdl:input>
#       <wsdl:output message="tns:AddBookResponse"></wsdl:output>
#     </wsdl:operation>
#   </wsdl:portType>

#   <wsdl:binding name="BookServiceSOAP" type="tns:BookService">
#     <soap:binding style="document"
#       transport="http://schemas.xmlsoap.org/soap/http" />
#     <wsdl:operation name="GetBook">
#       <soap:operation
#         soapAction="http://www.cleverbuilder.com/BookService/GetBook" />
#       <wsdl:input>
#         <soap:body use="literal" />
#       </wsdl:input>
#       <wsdl:output>
#         <soap:body use="literal" />
#       </wsdl:output>
#     </wsdl:operation>
#     <wsdl:operation name="AddBook">
#       <soap:operation
#         soapAction="http://www.cleverbuilder.com/BookService/AddBook" />
#       <wsdl:input>
#         <soap:body use="literal" />
#       </wsdl:input>
#       <wsdl:output>
#         <soap:body use="literal" />
#       </wsdl:output>
#     </wsdl:operation>
#   </wsdl:binding>

#   <wsdl:service name="BookService">
#     <wsdl:port binding="tns:BookServiceSOAP" name="BookServiceSOAP1">
#       <soap:address location="http://www.example.org/BookService" />
#     </wsdl:port>
#     <wsdl:port binding="tns:BookServiceSOAP" name="BookServiceSOAP2">
#       <soap:address location="http://www.example.org/BookService" />
#     </wsdl:port>
#   </wsdl:service>
# </wsdl:definitions>
# EOF
# }