param resourceToken string
param deploymentEnvironmentName string

var abbrs = loadJsonContent('./abbreviations.json')

output appInsightsName string = '${abbrs.insightsComponents}${resourceToken}-${deploymentEnvironmentName}'
output logAnalyticsWorkspaceName string = '${abbrs.operationalInsightsWorkspaces}${resourceToken}-${deploymentEnvironmentName}'
output apiManagementName string = '${abbrs.apiManagementService}${resourceToken}-${deploymentEnvironmentName}'
output appServicePlanName string = '${abbrs.webServerFarms}${resourceToken}-${deploymentEnvironmentName}'
output functionAppName string = '${abbrs.webSitesFunctions}${resourceToken}-${deploymentEnvironmentName}'
output storageAccountName string = toLower('${abbrs.storageStorageAccounts}${resourceToken}${deploymentEnvironmentName}')
output managedIdentityName string = '${abbrs.managedIdentityUserAssignedIdentities}${resourceToken}-${deploymentEnvironmentName}'
output keyVaultName string = '${abbrs.keyVaultVaults}${resourceToken}-${deploymentEnvironmentName}'
output apiManagementServiceName string = '${abbrs.apiManagementService}${resourceToken}-${deploymentEnvironmentName}'
