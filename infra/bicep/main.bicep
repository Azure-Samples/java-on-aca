targetScope = 'subscription'

@minLength(2)
@maxLength(32)
@description('Name of the the azd environment.')
param environmentName string

@minLength(2)
@description('Primary location for all resources.')
param location string

@description('Name of the the resource group. Default: rg-{environmentName}')
param resourceGroupName string

@description('Name of the the new containerapp environment. Default: aca-env-{environmentName}')
param managedEnvironmentsName string = ''

@description('Boolean indicating the aca environment only has an internal load balancer. ')
param vnetEndpointInternal bool = false

@description('Name of the the sql server. Default: sql-{environmentName}')
param sqlServerName string = ''

@description('Name of the the sql admin.')
param sqlAdmin string = 'sqladmin'

@description('The the sql admin password.')
@secure()
param sqlAdminPassword string

@description('Repo url of the configure server.')
param configGitRepo string

@description('Repo branch of the configure server.')
param configGitBranch string = 'main'

@description('Repo path of the configure server.')
param configGitPath string

@description('Name of the azure container registry.')
param acrName string
@description('Resource group of the azure container registry.')
param acrGroupName string = ''
@description('Subscription of the azure container registry.')
param acrSubscription string = ''

@description('Name of the log analytics server. Default la-{environmentName}')
param logAnalyticsName string = ''

@description('Name of the log analytics server. Default ai-{environmentName}')
param applicationInsightsName string = ''

@description('Images for petclinic services, will replaced by new images on step `azd deploy`')
param apiGatewayImage string = ''
param customersServiceImage string = ''
param vetsServiceImage string = ''
param visitsServiceImage string = ''
param adminServerImage string = ''
param chatAgentImage string = ''

@description('Name of the virtual network. Default vnet-{environmentName}')
param vnetName string = ''

var vnetPrefix = '10.1.0.0/16'
var infraSubnetPrefix = '10.1.0.0/24'
var infraSubnetName = '${abbrs.networkVirtualNetworksSubnets}infra'

var placeholderImage = 'azurespringapps/default-banner:distroless-2024022107-66ea1a62-87936983'

var abbrs = loadJsonContent('./abbreviations.json')
var tags = { 'azd-env-name': environmentName }

@description('Organize resources in a resource group')
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

module umiAcrPull 'modules/shared/userAssignedIdentity.bicep' = {
  name: 'umi-acr-pull'
  scope: rg
  params: {
    name: 'umi-${acrName}-acrpull'
  }
}

module umiApps 'modules/shared/userAssignedIdentity.bicep' = {
  name: 'umi-apps'
  scope: rg
  params: {
    name: 'umi-apps-${environmentName}'
  }
}

module vnet './modules/network/vnet.bicep' = {
  name: 'vnet'
  scope: rg
  params: {
    name: !empty(vnetName) ? vnetName : '${abbrs.networkVirtualNetworks}${environmentName}'
    location: location
    vnetAddressPrefixes: [vnetPrefix]
    subnets: [
      {
        name: infraSubnetName
        properties: {
          addressPrefix: infraSubnetPrefix
          delegations: [
            {
              name: 'ContainerAppsEnvInfra'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
        }
      }
    ]
    tags: tags
  }
}

module logAnalytics 'modules/shared/logAnalyticsWorkspace.bicep' = {
  name: 'log-analytics'
  scope: rg
  params: {
    name: !empty(logAnalyticsName) ? logAnalyticsName : 'la-${environmentName}'
    tags: tags
  }
}

@description('Azure Application Insights, the workload\' log & metric sink and APM tool')
module applicationInsights 'modules/shared/applicationInsights.bicep' = {
  name: 'application-insights'
  scope: rg
  params: {
    name: !empty(applicationInsightsName) ? applicationInsightsName : 'ai-${environmentName}'
    location: location
    workspaceResourceId: logAnalytics.outputs.logAnalyticsWsId
    tags: tags
  }
}

// group id: /subscriptions/<subscriptionId>/resourceGroups/<groupName>
var acrSub = !empty(acrSubscription) ? acrSubscription : split(rg.id, '/')[2]
var acrGroup = !empty(acrGroupName) ? acrGroupName : rg.name

@description('roles for Azure Container Registry')
module acrRoleAssignments 'modules/shared/containerRegistryRoleAssignment.bicep' = {
  name: 'acr-roles-assignments'
  scope: resourceGroup(acrSub, acrGroup)
  params: {
    name: acrName
    roleAssignments: [
      {
        principalId: umiAcrPull.outputs.principalId
        roleDefinitionIdOrName: 'AcrPull'
      }
    ]
  }
}

module managedEnvironment 'modules/containerapps/aca-environment.bicep' = {
  name: 'managedEnvironment'
  scope: rg
  params: {
    name: !empty(managedEnvironmentsName) ? managedEnvironmentsName : 'aca-env-${environmentName}'
    location: location
    vnetEndpointInternal: vnetEndpointInternal
    userAssignedIdentities: {
      '${umiAcrPull.outputs.id}': {}
      '${umiApps.outputs.id}': {}
    }
    diagnosticWorkspaceId: logAnalytics.outputs.logAnalyticsWsId
    subnetId: first(filter(vnet.outputs.vnetSubnets, x => x.name == infraSubnetName)).id
    tags: tags
  }
}

module javaComponents 'modules/containerapps/containerapp-java-components.bicep' = {
  name: 'javaComponents'
  scope: rg
  params: {
    managedEnvironmentsName: managedEnvironment.outputs.containerAppsEnvironmentName
    configServerGitRepo: configGitRepo
    configServerGitBranch: configGitBranch
    configServerGitPath: configGitPath
  }
}

module mysql 'modules/database/mysql.bicep' = {
  name: 'mysql'
  scope: rg
  params: {
    administratorLogin: sqlAdmin
    administratorLoginPassword: sqlAdminPassword
    serverName: !empty(sqlServerName) ? sqlServerName : '${abbrs.sqlServers}${environmentName}'
    databaseName: 'petclinic'
  }
}

module openai 'modules/ai/openai.bicep' = {
  name: 'openai'
  scope: rg
  params: {
    accountName: 'openai-${environmentName}'
    location: location
    appPrincipalId: umiApps.outputs.principalId
  }
}

module applications 'modules/app/petclinic.bicep' = {
  name: 'petclinic-microservices'
  scope: rg
  params: {
    managedEnvironmentsName: managedEnvironment.outputs.containerAppsEnvironmentName
    eurekaId: javaComponents.outputs.eurekaId
    configServerId: javaComponents.outputs.configServerId
    mysqlDBId: mysql.outputs.databaseId
    mysqlUserAssignedIdentityClientId: umiApps.outputs.clientId
    acrRegistry: '${acrRoleAssignments.outputs.registryName}.azurecr.io' // add dependency to make sure roles are assigned
    acrIdentityId: umiAcrPull.outputs.id
    apiGatewayImage: !empty(apiGatewayImage) ? apiGatewayImage : placeholderImage
    customersServiceImage: !empty(customersServiceImage) ? customersServiceImage : placeholderImage
    vetsServiceImage: !empty(vetsServiceImage) ? vetsServiceImage : placeholderImage
    visitsServiceImage: !empty(visitsServiceImage) ? visitsServiceImage : placeholderImage
    adminServerImage: !empty(adminServerImage) ? adminServerImage : placeholderImage
    chatAgentImage: !empty(chatAgentImage) ? chatAgentImage : placeholderImage
    targetPort: 8080
    applicationInsightsConnString: applicationInsights.outputs.connectionString
    azureOpenAiEndpoint: openai.outputs.endpoint
    openAiClientId: umiApps.outputs.id
  }
}

output subscriptionId string = subscription().subscriptionId
output resourceGroupName string = rg.name

output gatewayFqdn string = applications.outputs.gatewayFqdn
output adminFqdn string = applications.outputs.adminFqdn

output sqlDatabaseId string = mysql.outputs.databaseId
output sqlAdminIdentityClientId string = mysql.outputs.adminIdentityClientId
output sqlAdminIdentityId string = mysql.outputs.adminIdentityId
output sqlConnectName string = applications.outputs.connectionName

output appUserIdentityClientId string = umiApps.outputs.clientId
output appUserIdentityId string = umiApps.outputs.id

output customersServiceName string = applications.outputs.customersServiceName
output customersServiceId string = applications.outputs.customersServiceId
output vetsServiceName string = applications.outputs.vetsServiceName
output vetsServiceId string = applications.outputs.vetsServiceId
output visitsServiceName string = applications.outputs.visitsServiceName
output visitsServiceId string = applications.outputs.visitsServiceId
