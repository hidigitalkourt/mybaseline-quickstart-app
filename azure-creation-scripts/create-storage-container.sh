#!/usr/bin/env bash
set -eu

#This is used for creating the storage container in the terraform account so the privelaged for the service principle of the new app can be limited to the container
echo "Creating terraform storage container"
az storage container create --name "$TERRAFORM_CONTAINER_NAME" \
                            --account-name "$TERRAFORM_STORAGE_ACCOUNT_NAME" \
                            --subscription "$SUBSCRIPTION_ID" \
                            --out none