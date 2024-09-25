#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status.

# Inputs (provided by the GitHub Action)
USERNAME="$1"
PASSWORD="$2"
IMAGE_NAME="$3"
TAGS="${4:-latest}"  # Default to "latest" tag if none provided

# Log in to Docker Hub
echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin

# Build and tag the Docker image for each specified tag
for TAG in $(echo "$TAGS" | tr ',' '\n'); do
  echo "Building Docker image ${IMAGE_NAME}:${TAG}"
  docker build -t "${IMAGE_NAME}:${TAG}" .
done

# Push the Docker image for each tag
for TAG in $(echo "$TAGS" | tr ',' '\n'); do
  echo "Pushing Docker image ${IMAGE_NAME}:${TAG}"
  docker push "${IMAGE_NAME}:${TAG}"
done

# Log out from Docker Hub
docker logout
