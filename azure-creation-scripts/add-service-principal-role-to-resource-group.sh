#!/bin/bash
set -e
set -u

ROLE=$1
RESOURCE_GROUP_NAME=$2
SUBSCRIPTION=$3
SERVICE_PRINCIPAL_NAME=$4
 #This is how to `Contributor` role to the resource group so we can be authorized to make changes to the resource group with the app
echo "Adding $SERVICE_PRINCIPAL_NAME to $RESOURCE_GROUP_NAME in $SUBSCRIPTION Subscription"
SP_OBJECT_ID=$(az ad sp list --display-name "$SERVICE_PRINCIPAL_NAME" --query "[0].objectId" --out tsv)
RESOURCE_GROUP_ID=$(az group show --name $RESOURCE_GROUP_NAME --subscription $SUBSCRIPTION --query id --out tsv)
az role assignment create \
    --role $ROLE \
    --assignee-object-id $SP_OBJECT_ID \
    --assignee-principal-type ServicePrincipal  \
    --scope $RESOURCE_GROUP_ID \
    --output none