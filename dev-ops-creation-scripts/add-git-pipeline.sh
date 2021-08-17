#!/bin/bash
set -e
set -u

PIPELINE_NAME=$1
GIT_REPO_URL=$2
PROJECT_NAME=$3
BRANCH_NAME=$4
MY_ORG="https://dev.azure.com/MYORGNAME"

az pipelines create \
    --name $PIPELINE_NAME \
    --repository $GIT_REPO_URL \
    --branch $BRANCH_NAME \
    --project "$PROJECT_NAME" \
    --repository-type github \
    --organization $MY_ORG