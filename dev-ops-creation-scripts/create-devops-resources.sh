#!/bin/bash
set -e
set -u
#This is the base script that will create the over project on devops
PROJECT_NAME=$1

./create-project.sh $PROJECT_NAME