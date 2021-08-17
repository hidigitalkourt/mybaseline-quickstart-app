#!/usr/bin/env bash
set -eu

CONTAINER_REGISTRY_PASSWORD=$(az keyvault secret show --vault-name "MyContainerRegistryName" -n "Container-Registry-Password" --subscription "MySubscriptionName" | jq -r .value)

echo "Adding container registry password to project KeyVault"
az keyvault secret set --name "Container-Registry-Password" \
                       --vault-name "${KEYVAULT_NAME}" \
                       #This is just a description
                       --description "My ACR" \
                       --value "$CONTAINER_REGISTRY_PASSWORD" \
                       --subscription "$SUBSCRIPTION_ID" \
                       --out none