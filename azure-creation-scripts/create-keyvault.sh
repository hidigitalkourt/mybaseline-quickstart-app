#!/usr/bin/env bash
set -eu
#Create a resource group to hold the keyvault aside from the app so that tear down can be done easily and not need to get 
echo "Creating KeyVault Resource Group"
az group create --location "${LOCATION}" \
                --name "${KEYVAULT_RESOURCE_GROUP}" \
                --subscription "${SUBSCRIPTION_ID}" \
                --out none

echo "Creating KeyVault"
az keyvault create --name "${KEYVAULT_NAME}" \
                   --resource-group "${KEYVAULT_RESOURCE_GROUP}" \
                   --subscription "${SUBSCRIPTION_ID}" \
                   --out none
