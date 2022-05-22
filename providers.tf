terraform {
  required_providers{
      azurerm={
          source="hashicorp/azurerm"
          version = "=3.0.0"
      }
  }
}


provider "azurerm" {
    
    tenant_id = "63ce7d59-2f3e-42cd-a8cc-be764cff5eb6"
    subscription_id = "f84608ab-d9ac-4a5a-98b2-4c0438d0cf36"
    features {    
    }
}