#!/bin/bash
set -e
set -u

# Make sure that you have logged in before running this script using: az login
#Will only need to add ip address to sql server in the instance of using direct database connections

RESOURCE_GROUP=$1
SERVER_NAME=$2
RULE_NAME=$3
IP_ADDRESS=$4

az sql server firewall-rule create --resource-group $RESOURCE_GROUP --server $SERVER_NAME --name $RULE_NAME  --start-ip-address $IP_ADDRESS --end-ip-address $IP_ADDRESS