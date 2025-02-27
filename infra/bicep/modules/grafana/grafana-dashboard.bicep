targetScope = 'resourceGroup'

@description('Required. Name of your Azure Managed Grafana resource.')
param grafanaName string

@description('Required. Location of your Azure Managed Grafana resource.')
param location string

@description('Optional. Tags of the resource.')
param tags object = {}

module azureManagedGrafana 'azure-managed-grafana.bicep' = {
  name: grafanaName
  scope: resourceGroup()
  params: {
    grafanaName: grafanaName
    location: location
    tags: tags
  }
}

module grafanaRoleAssignment 'grafana-role-assignment.bicep' = {
  name: 'role-assignment-${grafanaName}'
  scope: resourceGroup()
  params: {
    grafanaPrincipalId: azureManagedGrafana.outputs.grafanaPrincipalId
  }
}

output grafanaDashboardEndpoint string = azureManagedGrafana.outputs.grafanaDashboardEndpoint

