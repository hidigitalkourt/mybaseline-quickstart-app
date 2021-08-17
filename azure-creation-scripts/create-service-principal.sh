#!/usr/bin/env bash
set -eu

#Similar to create-manage-servicel-principal this will likely not be used
echo "Creating service principal"
CLIENT_ID=$(az ad sp create-for-rbac --name "http://${APP_NAME}-${ENVIRONMENT}" --skip-assignment --query appId --out tsv)
SERVICE_PRINCIPAL_OBJECT_ID=$(az ad sp show --id ${CLIENT_ID} --query objectId --out tsv)

echo "Creating service principal credentials"
CLIENT_SECRET=$(az ad sp credential reset --name "${CLIENT_ID}" --end-date "2299-12-31" --query password --out tsv)

echo "Adding Client Secret to KeyVault"
az keyvault secret set --name "ClientSecret" \
                       --vault-name "${KEYVAULT_NAME}" \
                       --description "ClientId: ${CLIENT_ID}" \
                       --value "$CLIENT_SECRET" \
                       --subscription "$SUBSCRIPTION_ID" \
                       --out none

echo "Adding Service Principal access to keyvault"
az keyvault set-policy \
    --name "${KEYVAULT_NAME}" \
    --resource-group "${KEYVAULT_RESOURCE_GROUP}" \
    --object-id "$SERVICE_PRINCIPAL_OBJECT_ID" \
    --secret-permissions get list \
    --out none
