# Vars
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Store state in Azure Blob Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "shared-services"
    storage_account_name = "tomuvstore"
    container_name       = "tstate-edge"
    key                  = "terraform.tfstate"
  }
}

# Azure provider
provider "azurerm" {
  features {}
}

#random provider
provider "random" {
  version = "~> 3.0"
}

# Pseudorandom prefix
resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  number  = true
}

# Resource Group
resource "azurerm_resource_group" "edge" {
  name     = "k3s-rg"
  location = "westeurope"
}



