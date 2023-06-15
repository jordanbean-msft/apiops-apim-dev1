param apiManagementServiceName string
param location string
param publisherEmail string
param publisherName string
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managedIdentityName
}

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

output apiManagementName string = apiManagementService.name
