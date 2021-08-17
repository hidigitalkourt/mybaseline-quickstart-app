#!/usr/bin/env bash
set -eu
#Only need this if want to create a managed identity and going to likely never be the case
echo "Creating Managed Identity"
IDENTITY_PRINCIPAL_ID=$(az identity create --name "${APP_NAME}-${ENVIRONMENT}" --resource-group "${RESOURCE_GROUP_NAME}" --subscription "$SUBSCRIPTION_ID" --query principalId --out tsv)

echo "Adding MSI access to keyvault"
az keyvault set-policy \
    --name "${KEYVAULT_NAME}" \
    --resource-group "${KEYVAULT_RESOURCE_GROUP}" \
    --subscription "${SUBSCRIPTION_ID}" \
    --object-id "$IDENTITY_PRINCIPAL_ID" \
    --secret-permissions get list \
    --out none