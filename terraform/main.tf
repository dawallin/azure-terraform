provider "azurerm" {
  features {}
}

# Azure Resource Group
resource "azurerm_resource_group" "terraformResourceGroup" {
  name     = "dawallin-terraform-rg"
  location = "Sweden Central"
}

# Azure App Service Plan
resource "azurerm_app_service_plan" "terraformAppServicePlan" {
  name                = "dawallin-terraform-as"
  location            = azurerm_resource_group.terraformResourceGroup.location
  resource_group_name = azurerm_resource_group.terraformResourceGroup.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

# Azure App Service
resource "azurerm_app_service" "terraformAppService" {
  name                = "example-app-service"
  location            = azurerm_resource_group.terraformResourceGroup.location
  resource_group_name = azurerm_resource_group.terraformResourceGroup.name
  app_service_plan_id = azurerm_app_service_plan.terraformResourceGroup.id
}

# Terraform Backend Configuration
terraform {
  backend "azurerm" {
    resource_group_name   = "dawallin-shared"
    storage_account_name  = "dawallinsharedstorage"
    container_name        = "terraform"
    key                   = "terraform.tfstate"
  }
}