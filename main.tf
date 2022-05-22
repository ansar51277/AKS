resource "azurerm_resource_group" "rg" {
    name = "${var.rgname.name}"
    location = "${var.rgname.location}"
    #tags = "${var.rgname.tags}}"
    tags = {
      "dev" = "AKS"
    }
  
}

resource "azurerm_container_registry" "ak" {
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    name = "humdrumtest"
    sku = "Standard"
    identity {
       type = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.aksidentity.id]
    }
  depends_on    = [azurerm_user_assigned_identity.aksidentity]
}

resource "azurerm_user_assigned_identity" "aksidentity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name = "identity1"
  #object = azurerm_user_assigned_identity.aksidentity.principal_id
}


resource "azurerm_role_assignment" "aksrole" {
    scope = azurerm_container_registry.ak.id
    principal_id = azurerm_user_assigned_identity.aksidentity.principal_id
    depends_on    = [azurerm_user_assigned_identity.aksidentity]
    role_definition_name = "Acrpull"
  
}


resource "azurerm_kubernetes_cluster" "aks" {
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    kubernetes_version = "1.22.6"
    name = "aksnew"
    dns_prefix = "aks-dns"
        identity {
      type = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.aksidentity.id]
      
          }

       
    
      default_node_pool {
      name = "aksdefault"
      vm_size = "Standard_B2ms"
      enable_auto_scaling = true
      #enable_host_encryption = true
      max_pods = 50
      min_count = 1
      max_count = 15
      node_count = 1
      os_sku = "Ubuntu"
      os_disk_size_gb = 1000
      #type = "AvailabilitySet"
      zones = [ "1" ,"2" ,"3" ]
           
      #scale_method = "Autoscale"
      #os_type = "Linux"
         
    }


  network_profile {
        load_balancer_sku = "standard"
        network_plugin = "kubenet"
    }

depends_on    = [azurerm_user_assigned_identity.aksidentity]

}
 






