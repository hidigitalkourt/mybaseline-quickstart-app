#!/usr/bin/env bash
set -eu

#This is creating the resource group for the application. In short this is a container that will hold the tables, queues, function app, app insights...etc
echo "Creating Resource Groups"
az group create --location "${LOCATION}" \
                --name "${RESOURCE_GROUP_NAME}" \
                --subscription "${SUBSCRIPTION_ID}" \
                --out none