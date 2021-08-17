#!/bin/bash
set -e
set -u
#This is the script that created a devops project base
PROJECT_NAME=$1
MY_ORG="https://dev.azure.com/MYORGNAME"

echo "Creating new DevOps project with name $PROJECT_NAME"
az devops project create --name "$PROJECT_NAME" --org $MY_ORG

#Include some dummy vairables because otherwise the library won't be created as empty
echo "Creating empty variable groups (Libraries) in project..."
echo "    Creating ${PROJECT_NAME}-Dev"
az pipelines variable-group create --name "${PROJECT_NAME}-Dev" --organization $MY_ORG --project $PROJECT_NAME --authorize=true --variables dummy=dummy
echo "    Creating ${PROJECT_NAME}-Prod"
az pipelines variable-group create --name "${PROJECT_NAME}-Prod" --organization $MY_ORG --project $PROJECT_NAME --authorize=true --variables dummy=dummy
