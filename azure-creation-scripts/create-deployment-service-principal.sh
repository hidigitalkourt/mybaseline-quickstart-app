#!/usr/bin/env bash
set -eu

echo "Creating deployment service principal"
CLIENT_NAME="${APP_NAME}Deployment-${ENVIRONMENT}"
CLIENT_ID=$(az ad sp create-for-rbac --name "http://${CLIENT_NAME}" --skip-assignment --query appId --out tsv)
SERVICE_PRINCIPAL_OBJECT_ID=$(az ad sp show --id ${CLIENT_ID} --query objectId --out tsv)
                         
echo "Creating service principal credentials"
#Create a service principal that never expires
CLIENT_SECRET=$(az ad sp credential reset --name "${CLIENT_ID}" --end-date "2299-12-31" --query password --out tsv)

#Add client id and secret to keyvault to make things easier for fetching for az login during deployments
echo "Adding Client ID to KeyVault"
az keyvault secret set --name "ClientId-Deployment" \
                       --vault-name "${KEYVAULT_NAME}" \
                       --description "DisplayName: ${CLIENT_NAME}" \
                       --value "$CLIENT_ID" \
                       --subscription "$SUBSCRIPTION_ID" \
                       --out none

echo "Adding Client Secret to KeyVault"
az keyvault secret set --name "ClientSecret-Deployment" \
                       --vault-name "${KEYVAULT_NAME}" \
                       --description "ClientId: ${CLIENT_ID}" \
                       --value "$CLIENT_SECRET" \
                       --subscription "$SUBSCRIPTION_ID" \
                       --out none

echo "Adding deployment service principal access to KeyVault"
az role assignment create --role "Key Vault Contributor" \
                          --assignee-object-id "$SERVICE_PRINCIPAL_OBJECT_ID" \
                          --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${KEYVAULT_RESOURCE_GROUP}/providers/Microsoft.KeyVault/vaults/${KEYVAULT_NAME}" \
                          --out none

echo "Adding access policy on keyvault"
az keyvault set-policy \
    --name "${KEYVAULT_NAME}" \
    --resource-group "${KEYVAULT_RESOURCE_GROUP}" \
    --object-id "$SERVICE_PRINCIPAL_OBJECT_ID" \
    --secret-permissions get list \
    --subscription "$SUBSCRIPTION_ID" \
    --out none

#Deployment service principal need to be able to update the application with changes so it definately need contributor role assigned
echo "Adding deployment service principal Contributor role on resource group"
az role assignment create --role "Contributor" \
                          --assignee-object-id "$SERVICE_PRINCIPAL_OBJECT_ID" \
                          --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}" \
                          --out none
#Deployment need to be able to update terraform which will live outside of the applications resource group
echo "Adding deployment service principal access to Terraform storage account and container"
az role assignment create --role "Reader and Data Access" \
                          --assignee-object-id "$SERVICE_PRINCIPAL_OBJECT_ID" \
                          --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${TERRAFORM_STORAGE_ACCOUNT_NAME}/providers/Microsoft.Storage/storageAccounts/${TERRAFORM_STORAGE_ACCOUNT_NAME}" \
                          --out none
#Deployment need to be able to update terraform which will live outside of the applications inside of specific container if so specified for least priveledge
az role assignment create --role "Storage Blob Data Contributor" \
                          --assignee-object-id "$SERVICE_PRINCIPAL_OBJECT_ID" \
                          --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${TERRAFORM_STORAGE_ACCOUNT_NAME}/providers/Microsoft.Storage/storageAccounts/${TERRAFORM_STORAGE_ACCOUNT_NAME}/blobServices/default/containers/${TERRAFORM_CONTAINER_NAME}" \
                          --out none
