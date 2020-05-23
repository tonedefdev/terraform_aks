resource "azurerm_resource_group" "k8s" {
  name      = var.rg_name
  location  = var.location
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "k8s_logs_workspace" {
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "k8s_logs_solution" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.k8s_logs_workspace.location
  resource_group_name   = azurerm_resource_group.k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.k8s_logs_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.k8s_logs_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = "1.16.7"

  linux_profile {
    admin_username  = "tonedefadmin"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name        = "agentpool"
    node_count  = var.agent_count
    vm_size     = "Standard_DS1_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent{
      enabled                     = true
      log_analytics_workspace_id  = azurerm_log_analytics_workspace.k8s_logs_workspace.id
    }
  }
}