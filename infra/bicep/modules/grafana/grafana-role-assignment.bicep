targetScope = 'resourceGroup'

@description('Required. The principal ID of the Managed Identity for the Grafana resource.')
param grafanaPrincipalId string

@description('Optional. The role definition ID for the Monitoring Reader role. Default: Monitoring Reader role.')
param grafanaRoleDefinitionId string = 'b0d8363b-8ddd-447d-831f-62ca05bff136' // Monitoring Reader role

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, grafanaPrincipalId, grafanaRoleDefinitionId)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', grafanaRoleDefinitionId)
    principalId: grafanaPrincipalId
    principalType: 'ServicePrincipal'
  }
}
