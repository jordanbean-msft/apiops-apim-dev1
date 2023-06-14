param resourceToken string

var abbrs = loadJsonContent('./abbreviations.json')

output appInsightsName string = '${abbrs.insightsComponents}${resourceToken}'
output logAnalyticsWorkspaceName string = '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
output apiManagementName string = '${abbrs.apiManagementService}${resourceToken}'
output appServicePlanName string = '${abbrs.webServerFarms}${resourceToken}'
output functionAppName string = '${abbrs.webSitesFunctions}${resourceToken}'
output storageAccountName string = '${abbrs.storageStorageAccounts}${resourceToken}'
