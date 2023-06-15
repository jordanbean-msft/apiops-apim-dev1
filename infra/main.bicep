targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string
param publisherEmail string
param publisherName string
param userObjectId string
param resourceGroupName string = ''
param deploymentEnvironmentName string
param shouldDeployApim bool = true

@description('Id of the user or app to assign application roles')

var abbrs = loadJsonContent('./app/abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

module names './app/resource-names.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'resource-names'
  params: {
    resourceToken: resourceToken
    deploymentEnvironmentName: deploymentEnvironmentName
  }
}

module loggingDeployment './app/logging.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'logging-deployment'
  params: {
    appInsightsName: names.outputs.appInsightsName
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
    location: location
    tags: tags
  }
}

module managedIdentityDeployment './app/managed-identity.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'managed-identity-deployment'
  params: {
    managedIdentityName: names.outputs.managedIdentityName
    location: location
    tags: tags
  }
}

module keyVaultDeployment './app/key-vault.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'key-vault-deployment'
  params: {
    keyVaultName: names.outputs.keyVaultName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: names.outputs.managedIdentityName
    tags: tags
    userObjectId: userObjectId
  }
}

module functionDeployment './app/function.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'function-deployment'
  params: {
    appInsightsName: loggingDeployment.outputs.appInsightsName
    appServicePlanName: names.outputs.appServicePlanName
    functionAppName: names.outputs.functionAppName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    storageAccountName: names.outputs.storageAccountName
    tags: union(tags, { 'azd-service-name': 'func' })
    deploymentEnvironmentName: deploymentEnvironmentName
  }
}

module apimDeployment 'app/apim.bicep' = if (shouldDeployApim) {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'apim-deployment'
  params: {
    apiManagementServiceName: names.outputs.apiManagementServiceName
    location: location
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output KEY_VAULT_NAME string = keyVaultDeployment.outputs.keyVaultName
output FUNCTION_APP_NAME string = functionDeployment.outputs.functionAppName
output RESOURCE_GROUP_NAME string = resourceGroup.name
