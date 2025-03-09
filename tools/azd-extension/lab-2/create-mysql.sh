#!/bin/bash

UNIQUEID=$(openssl rand -hex 3)
APPNAME=petclinic

RESOURCE_GROUP=$(az group list --query "[?contains(name, 'petclinic')].{Name:name}[0]" -o tsv)

# This script creates an Azure MySQL server and an Azure Container Registry (ACR) in a specified resource group.
MYSQL_SERVER_NAME=mysql-$APPNAME-$UNIQUEID
MYSQL_ADMIN_USERNAME=sqladmin
MYSQL_ADMIN_PASSWORD="5qVYxsoyaV9qJN"
DATABASE_NAME=petclinic

az mysql flexible-server create \
    --admin-user "$MYSQL_ADMIN_USERNAME" \
    --admin-password "$MYSQL_ADMIN_PASSWORD" \
    --name "$MYSQL_SERVER_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --public-access none \
    --yes
az mysql flexible-server db create \
    --server-name $MYSQL_SERVER_NAME \
    --resource-group $RESOURCE_GROUP \
    -d $DATABASE_NAME

#
# Allow public access to the MySQL server
#
az mysql flexible-server firewall-rule create \
    --rule-name allAzureIPs \
    --name $MYSQL_SERVER_NAME \
    --resource-group $RESOURCE_GROUP \
    --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
