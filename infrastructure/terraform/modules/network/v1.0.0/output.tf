
// define outputs on which others will depend

output "theid" {
    value = "${azurerm_resource_group.rg.id}"
}