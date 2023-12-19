provider "azurerm" {
  features {}
}

# Azure Resource Group
resource "azurerm_resource_group" "terraformResourceGroup" {
  name     = "dawallin-blazor-rg"
  location = "West Europe"
}

# Azure Storage Account
resource "azurerm_storage_account" "log_storage_account" {
  name                     = "dawallinblazorsa"
  resource_group_name      = azurerm_resource_group.terraformResourceGroup.name
  location                 = azurerm_resource_group.terraformResourceGroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "log_storage_container" {
  name                  = "logcontainer"
  storage_account_name  = azurerm_storage_account.log_storage_account.name
  container_access_type = "private"
}

resource "azurerm_application_insights" "terraform_applicationinsight" {
  name                = "dawallin-blazor-ai"
  location            = azurerm_resource_group.terraformResourceGroup.location
  resource_group_name = azurerm_resource_group.terraformResourceGroup.name
  application_type    = "web"
}

# Azure App Service Plan
resource "azurerm_service_plan" "terraformAppServicePlan" {
  name                = "dawallin-blazor-as"
  location            = azurerm_resource_group.terraformResourceGroup.location
  resource_group_name = azurerm_resource_group.terraformResourceGroup.name
  os_type = "Linux"
  sku_name = "F1"
}

# Azure App Service
resource "azurerm_linux_web_app" "terraformAppService" {
  name                = "dawallin-blazor-wa"
  location            = azurerm_resource_group.terraformResourceGroup.location
  resource_group_name = azurerm_resource_group.terraformResourceGroup.name
  service_plan_id     = azurerm_service_plan.terraformAppServicePlan.id 

  site_config {
    always_on = false
    application_stack {
      dotnet_version = "8.0"
    }
    app_command_line = "dotnet BlazorTest.dll"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.terraform_applicationinsight.instrumentation_key
    "ASPNETCORE_ENVIRONMENT" = "Production"
  }
}

# Terraform Backend Configuration
terraform {
  backend "azurerm" {
    resource_group_name   = "dawallin-shared"
    storage_account_name  = "dawallinsharedstorage"
    container_name        = "terraform"
    key                   = "blazor.tfstate"
  }
}