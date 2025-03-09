#!/bin/bash
#
# Before deploying applications to the Azure Container Apps environment, you’ll need an Azure Container Registry instance that allows you to build and save your application container images. 
# You’ll also need to allow your Container Apps environment to pull images from this new container registry.
#
# To give the Container Apps environment secure access to the container registry, we’ll create a user managed identity and assign it the required privileges to use the images stored in your Azure Container Registry.

APPNAME=petclinic
RESOURCE_GROUP=$(az group list --query "[?contains(name, 'petclinic')].{Name:name}[0]" -o tsv)
echo "Resource group: $RESOURCE_GROUP"
if [ -z "$RESOURCE_GROUP" ]; then
    echo "Error: Resource group not found."
    exit 1
fi

# Check if a container registry containing the string $APPNAME already exists
EXISTING_ACR=$(az acr list --resource-group $RESOURCE_GROUP --query "[?contains(name, '$APPNAME')].{Name:name}[0]" -o tsv)

UNIQUEID=$(openssl rand -hex 3)
if [ -n "$EXISTING_ACR" ]; then
    echo "Container registry [$EXISTING_ACR] already exists. Skipping creation."
    MYACR=$EXISTING_ACR
else    
    MYACR=acr$APPNAME$UNIQUEID
    az acr create \
        -n $MYACR \
        -g $RESOURCE_GROUP \
        --sku Basic \
        --admin-enabled true
fi

# Check if ACA environment name containing string "acalab-env" exists
ACA_ENVIRONMENT=$(az containerapp env list --resource-group $RESOURCE_GROUP --query "[?contains(name, 'acalab-env')].{Name:name}[0]" -o tsv)

if [ -z "$ACA_ENVIRONMENT" ]; then
    echo "Error: ACA environment containing 'acalab-env' not found."
    exit 1
fi

# Disable path conversion for MSYS (Git Bash)
export MSYS_NO_PATHCONV=1

# Create the identity that your container apps will use.
APPS_IDENTITY=uid-petclinic-$UNIQUEID
az identity create --resource-group $RESOURCE_GROUP --name $APPS_IDENTITY --output json

APPS_IDENTITY_ID=$(az identity show --resource-group $RESOURCE_GROUP --name $APPS_IDENTITY --query id --output tsv)
APPS_IDENTITY_SP_ID=$(az identity show --resource-group $RESOURCE_GROUP --name $APPS_IDENTITY --query principalId --output tsv)

echo "Assign the user identity to your Azure Container Apps environment."
az containerapp env identity assign -g $RESOURCE_GROUP -n $ACA_ENVIRONMENT --user-assigned $APPS_IDENTITY_ID

# Grant the identity with the necessary privileges to pull images from the container registry.
ACR_ID=$(az acr show -n $MYACR -g $RESOURCE_GROUP --query id -o tsv)
az role assignment create --assignee $APPS_IDENTITY_SP_ID --scope $ACR_ID --role acrpull

