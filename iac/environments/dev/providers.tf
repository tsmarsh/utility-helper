terraform {
  cloud {
    organization = "BlackShapes"

    workspaces {
      name = "utilityhelper-dev"
    }
  }
}

provider "azurerm" {
  features {}
}
