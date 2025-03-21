targetScope = 'resourceGroup'

@description('Required. Name of your Azure Managed Grafana resource.')
param grafanaName string

@description('Required. Location for the Azure Managed Grafana resource.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

resource grafana 'Microsoft.Dashboard/grafana@2023-10-01-preview' = {
  name: grafanaName
  location: location
  properties: {
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Disabled'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
    apiKey: 'Disabled'
    deterministicOutboundIP: 'Disabled'
    grafanaMajorVersion: '10'
  }
  tags: tags
  sku: {
    name: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output grafanaDashboardEndpoint string = grafana.properties.endpoint
output grafanaPrincipalId string = grafana.identity.principalId
