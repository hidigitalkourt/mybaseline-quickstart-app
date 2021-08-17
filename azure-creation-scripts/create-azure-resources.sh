#!/usr/bin/env bash
set -eu

## *** Must first login to Azure via az login ***
echo "Getting your subscription list based on your current az login credentials..."
az account list --query "[?contains(name, 'HISC')].{Name: name, SubscriptionId: id}" --out table

# *** Requires the following Environment variables to be set ***
echo "Set required environment variables"
echo
read -e -p 'ENVIRONMENT (Suffix for your resources, e.g., "Dev" or "Prod") : ' -i "${ENVIRONMENT:-Dev}" ENVIRONMENT
lowercase_environment=$(echo $ENVIRONMENT | tr '[:upper:]' '[:lower:]')
read -e -p 'APP_NAME (e.g. "MyApp") : ' -i "${APP_NAME:-MyApp}" APP_NAME
lowercase_app=$(echo $APP_NAME | tr '[:upper:]' '[:lower:]')
read -e -p 'SUBSCRIPTION_ID (the GUID, e.g., "00000000-0000-0000-0000-000000000000") : ' -i "${SUBSCRIPTION_ID:-}" SUBSCRIPTION_ID
default_tf_storage_account="my${lowercase_environment}terraform"
default_tf_container="${lowercase_app}"
read -e -p 'TERRAFORM_STORAGE_ACCOUNT_NAME (e.g., "mydevterraform") : ' -i "${TERRAFORM_STORAGE_ACCOUNT_NAME:-$default_tf_storage_account}" TERRAFORM_STORAGE_ACCOUNT_NAME
read -e -p 'TERRAFORM_CONTAINER_NAME (e.g., "myapp") : ' -i "${TERRAFORM_CONTAINER_NAME:-$default_tf_container}" TERRAFORM_CONTAINER_NAME
#Creating an app to run on the system assigned service identity makes it so that the identity is coupled to the resource. Create one, create the other. Delete one, delete the other.
# This helps with following "least privelage" guidelines
cat <<MENU

Your application will run as a system-assigned Managed Service Identity by default.
If you prefer, you may create a Service Principal or a user-created Managed Service Identity (MSI) to run as.

How do you want to run your app?
    1) System-Assigned MSI
    2) User-Created MSI
    3) Service Principal
MENU
read -e -p 'Type of identity to create: ' -i "1" CREATE_OPTION

export ENVIRONMENT
export APP_NAME
export SUBSCRIPTION_ID
export TERRAFORM_STORAGE_ACCOUNT_NAME
export TERRAFORM_CONTAINER_NAME

# Derived resource names that are used several places

RESOURCE_GROUP_NAME="${APP_NAME}-${ENVIRONMENT}"
KEYVAULT_RESOURCE_GROUP="${APP_NAME}KeyVault${ENVIRONMENT}"
KEYVAULT_NAME="${APP_NAME}-${ENVIRONMENT}"

export RESOURCE_GROUP_NAME
export KEYVAULT_RESOURCE_GROUP
export KEYVAULT_NAME

export LOCATION="centralus"

./create-base-resource-group.sh
./create-keyvault.sh
./add-docker-credentials-to-keyvault.sh
./create-storage-container.sh
./create-deployment-service-principal.sh

case "$CREATE_OPTION" in
    2) ./create-managed-identity.sh
       ;;
    3) ./create-service-principal.sh
       ;;
    *) echo "Skipping identity creation, using default system-assigned MSI"
esac

echo "Done creating Azure resources!"