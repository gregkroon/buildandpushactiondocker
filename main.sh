#!/bin/bash

set -e  # Exit immediately if any command fails

# Get the inputs from the GitHub workflow
USERNAME="${INPUT_USERNAME}"
PASSWORD="${INPUT_PASSWORD}"
IMAGE_NAME="${INPUT_IMAGE_NAME}"
TAGS="${INPUT_TAGS:-latest}"  # Default tag is 'latest'

# Docker login
echo "${PASSWORD}" | docker login -u "${USERNAME}" --password-stdin

# Build the Docker image for each tag
for TAG in $(echo $TAGS | tr ',' '\n'); do
  echo "Building Docker image ${IMAGE_NAME}:${TAG}"
  docker build -t "${IMAGE_NAME}:${TAG}" .
done

# Push the Docker image for each tag
for TAG in $(echo $TAGS | tr ',' '\n'); do
  echo "Pushing Docker image ${IMAGE_NAME}:${TAG}"
  docker push "${IMAGE_NAME}:${TAG}"
done

# Docker logout
docker logout

