#!/bin/bash
#
# Configure the config, discovery, and admin applications. These are available as built-in components of Azure Container Apps.

APPNAME=petclinic
RESOURCE_GROUP=$(az group list --query "[?contains(name, 'petclinic')].{Name:name}[0]" -o tsv)
echo "Resource group: $RESOURCE_GROUP"
if [ -z "$RESOURCE_GROUP" ]; then
    echo "Error: Resource group not found."
    exit 1
fi

LOCATION=$(az group show --name $RESOURCE_GROUP --query "location" -o tsv)

# Create the Spring Cloud Config Server Java component. You’ll need to pass the Git repo information you defined back 
# in the Config repo step to correctly load your configuration information.
GIT_URI="https://github.com/Azure-Samples/java-on-aca.git"
SEARCH_PATH="config"
LABEL=main

# Check if ACA environment name containing string "acalab-env" exists
ACA_ENVIRONMENT=$(az containerapp env list --resource-group $RESOURCE_GROUP --query "[?contains(name, 'acalab-env')].{Name:name}[0]" -o tsv)

if [ -z "$ACA_ENVIRONMENT" ]; then
    echo "Error: ACA environment containing 'acalab-env' not found."
    exit 1
fi

JAVA_CONFIG_COMP_NAME=configserver
az containerapp env java-component config-server-for-spring create \
    --environment $ACA_ENVIRONMENT \
    --resource-group $RESOURCE_GROUP \
    --name $JAVA_CONFIG_COMP_NAME \
    --set-configuration spring.cloud.config.server.git.uri=$GIT_URI spring.cloud.config.server.git.search-paths=$SEARCH_PATH spring.cloud.config.server.git.default-label=$LABEL

# Check the Spring Cloud Config Server Java component to confirm that it was successfully created.
CONFIG_SERVER_EXISTS=$(az containerapp env java-component config-server-for-spring show \
    --environment $ACA_ENVIRONMENT \
    --resource-group $RESOURCE_GROUP \
    --name $JAVA_CONFIG_COMP_NAME --query "name" -o tsv)

if [ -z "$CONFIG_SERVER_EXISTS" ]; then
    echo "Error: Config server was not successfully created."
    exit 1
fi

# Create the Spring Cloud Eureka Server Java component. This will create a standard Eureka endpoint within 
# the Container Apps environment. The Spring Petclinic workload will use this for discovery services.
JAVA_EUREKA_COMP_NAME=eureka
az containerapp env java-component eureka-server-for-spring create \
    --environment $ACA_ENVIRONMENT \
    --resource-group $RESOURCE_GROUP \
    --name $JAVA_EUREKA_COMP_NAME \
    --set-configuration eureka.server.response-cache-update-interval-ms=10000

# Create a new Spring Boot Admin application and bind it to the Eureka Server 
JAVA_SBA_COMP_NAME=springbootadmin
az containerapp env java-component admin-for-spring create \
    --environment $ACA_ENVIRONMENT \
    --resource-group $RESOURCE_GROUP \
    --name $JAVA_SBA_COMP_NAME \
    --bind $JAVA_EUREKA_COMP_NAME \
    --min-replicas 1 \
    --max-replicas 1
