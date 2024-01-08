variable "location" {}

variable "resource_group" {}

variable "connection_string" {}

variable "security_group" {}

variable "image" {}

variable "cpu" {
  default = "0.5"
}

variable "memory" {
  default = "1.5"
}

resource "azurerm_container_group" "ava" {
  name                = "uh-container-group"
  location            = var.location
  resource_group_name = var.resource_group
  os_type             = "Linux"

  container {
    name   = "bounded-contexts"
    image  = var.image
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      "MONGO_URI" = var.connection_string
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "ug-bounded-contexts"
}

resource "azurerm_network_security_rule" "ava" {
  name                        = "HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = var.security_group
}
