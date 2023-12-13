provider "azurerm" {
  features {}
}

# Azure Resource Group
resource "azurerm_resource_group" "terraformResourceGroup" {
  name     = "dawallin-terraform-rg2"
  location = "West Europe"
}

# Azure App Service Plan
resource "azurerm_service_plan" "terraformAppServicePlan" {
  name                = "dawallin-terraform-as2"
  location            = azurerm_resource_group.terraformResourceGroup.location
  resource_group_name = azurerm_resource_group.terraformResourceGroup.name
  os_type = "Linux"
  sku_name = "F1"
}

# Azure App Service
resource "azurerm_linux_web_app" "terraformAppService" {
  name                = "dawallin-terraform-wa2"
  location            = azurerm_resource_group.terraformResourceGroup.location
  resource_group_name = azurerm_resource_group.terraformResourceGroup.name
  service_plan_id = azurerm_service_plan.terraformAppServicePlan.id 
  site_config {}
}

# Terraform Backend Configuration
terraform {
  backend "azurerm" {
    resource_group_name   = "dawallin-shared"
    storage_account_name  = "dawallinsharedstorage"
    container_name        = "terraform"
    key                   = "terraform2.tfstate"
  }
}