# service_principal.tf | Service Principal Configuration

resource "azuread_application" "app" {
  display_name = "${var.app_name}-app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "app" {
  application_id               = azuread_application.app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal password
resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.id
}

# Assign roles
resource "azurerm_role_assignment" "storage" {
  scope                 = data.azurerm_subscription.current.id
  role_definition_name  = "Storage Blob Data Reader"
  principal_id          = azuread_service_principal.app.id
}

# Custom role for creating container instance executors
resource "azurerm_role_definition" "custom_role" {
  name               = "${var.app_name}-custom-role"
  scope              = data.azurerm_subscription.current.id

  permissions {
    actions     = [
      "Microsoft.ContainerInstance/containerGroups/read",
      "Microsoft.ContainerInstance/containerGroups/write",
      "Microsoft.ContainerInstance/containerGroups/delete",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "custom_role" {
  scope                 = data.azurerm_subscription.current.id
  role_definition_id    = azurerm_role_definition.custom_role.role_definition_resource_id
  principal_id          = azuread_service_principal.app.id
}
