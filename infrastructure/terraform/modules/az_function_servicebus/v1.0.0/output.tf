
// define outputs on which others will depend

output "theid" {
    value = "${azurerm_linux_function_app.az_func_app.id}"
}

output "thename" {
    value = "${azurerm_linux_function_app.az_func_app.name}"
}