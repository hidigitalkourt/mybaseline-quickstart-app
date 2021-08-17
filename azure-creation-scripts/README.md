# Azure Creation Scripts

This is a collection of scripts used to create resources in Azure for a skeleton project

 __Must be logged into Azure. Log in with the following command:  `az login`__

## Standard Use

 Run `create-azure-resources.sh`.  The script will prompt you for all needed information, then create everything you need in Azure for a skeleton project.  

### Information you will need

`create-azure-resources.sh` will prompt you for the following pieces of information:

- ENVIRONMENT (e.g., "Dev" or "Prod")
- APP_NAME (e.g., "MyReallyCoolApplication")
- SUBSCRIPTION_ID (the GUID, e.g., "00000000-0000-0000-0000-000000000000")
- TERRAFORM_STORAGE_ACCOUNT_NAME (e.g., "mydevterraform")
- TERRAFORM_CONTAINER_NAME (e.g., "myreallycoolapplication-terraform")

### Defaults

`create-azure-resources.sh` will use the following defaults:

- RESOURCE_GROUP_NAME:  `${APP_NAME}-${ENVIRONMENT}`
- KEYVAULT_RESOURCE_GROUP  `${APP_NAME}KeyVault${ENVIRONMENT}`
- KEYVAULT_NAME:  `${APP_NAME}-${ENVIRONMENT}`

## create-azure-resources script

This script is a user-friendly master script to create everything you need in Azure for a skeleton project. This will run all of the below scripts.

## create-base-resource-group script

Creates the base resource group with the name `${RESOURCE_GROUP_NAME}`.

## create-keyvault script

Creates a KeyVault Resource Group named `${KEYVAULT_RESOURCE_GROUP}` and a KeyVault named `${KEYVAULT_NAME}` in that resource group.

## create-storage-container script

Creates a storage container named `${TERRAFORM_CONTAINER_NAME}` in the storage account specified by `${TERRAFORM_STORAGE_ACCOUNT_NAME}`.

## create-deployment-service-principal script

Creates a deployment service principal named `${APP_NAME}Deployment-${ENVIRONMENT}`; creates a client secret and adds the secret to the KeyVault; adds permissions for the Service Principal to the terraform storage account and container; and gives the Service Principal `Contributor` role on the resource group.

## create-service-principal script (OPTIONAL)

Creates a service principal named `${APP_NAME}-${ENVIRONMENT}`, creates a client secret, adds the secret to the KeyVault, and adds permissions for the Service Principal to access the KeyVault.

## create-managed-identity script (OPTIONAL)

Creates a Managed Identity with name `${APP_NAME}-${ENVIRONMENT}` and adds list and get permissions for that identity to the KeyVault

## add-service-principal-role-to-resource-group script

This script is not called by `create-azure-resources.sh`.

Gives a role to a service principal, probably the deployment service principal (`${APP_NAME}Deployment-${ENVIRONMENT}`) created using `create-deployment-service-principal.sh`.
