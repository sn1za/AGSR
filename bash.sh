#!/bin/bash

PROJECT_NAME=landing
IMAGE='mynginx'
DOCKER_REGISTRY='someRegistry'
PROJECT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BUILD_NUMBER=$(git log -n 1 --pretty=format:'%h')


cd nginx/
docker build . -t "$DOCKER_REGISTRY"/"$IMAGE":"$PROJECT_BRANCH"-"$BUILD_NUMBER"
docker push "$DOCKER_REGISTRY"/"$IMAGE":"$PROJECT_BRANCH"-"$BUILD_NUMBER"

cd ../helm/
helm lint . --values ${PROJECT_NAME}.yaml --set PROJECT_BRANCH=${PROJECT_BRANCH} --set BUILD_NUMBER=${BUILD_NUMBER} --set PROJECT_NAME=${PROJECT_NAME} --set DOCKER_REGISTRY=${DOCKER_REGISTRY} && \ 
helm upgrade --install ${PROJECT_NAME} . --values ${PROJECT_NAME}.yaml --set PROJECT_BRANCH=${PROJECT_BRANCH} --set BUILD_NUMBER=${BUILD_NUMBER} --set PROJECT_NAME=${PROJECT_NAME} --set DOCKER_REGISTRY=${DOCKER_REGISTRY} --atomic --debug --timeout 800s --create-namespace --namespace myapp-namespace 


