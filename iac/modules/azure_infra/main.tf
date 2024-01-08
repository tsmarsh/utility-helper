variable "name" {
  default = "utility-resources"
}

variable "location" {
  default = "East US"
}

resource "azurerm_resource_group" "utility" {
  name     = var.name
  location = var.location
}

resource "azurerm_network_security_group" "utility" {
  name                = "uh-nsg"
  location            = azurerm_resource_group.utility.location
  resource_group_name = azurerm_resource_group.utility.name
}

output "security_group" {
  value = azurerm_network_security_group.utility.name
}

output "resource_group" {
  value = azurerm_resource_group.utility.name
}

output "location" {
  value = azurerm_resource_group.utility.location
}
