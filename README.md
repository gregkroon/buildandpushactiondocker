# Build and Push Action Docker

This repository contains a custom GitHub Action that facilitates building and pushing Docker images using Harness CI pipelines the drone plugin for github actions 

## Overview

This action is designed to automate Docker image builds and push processes, leveraging the `plugins/github-actions` within Harness CI pipelines. It allows for flexible Docker image management, including multi-stage builds and tag management, all integrated with DockerHub.

## Prerequisites

- **DockerHub Account**: Ensure that you have a DockerHub account, and store the credentials securely in the Drone CI pipeline secrets.
- **Drone CI**: Make sure the Drone plugin is properly set up for your project.
- **GitHub Token**: A GitHub token is needed and should be added to your Drone secrets to authenticate with GitHub repositories.

## Usage

Below is the YAML configuration for using this action in your Drone CI pipeline:

```yaml
- step:
    type: Plugin
    name: Build and Push Docker Action
    identifier: build_and_push_docker
    spec:
      connectorRef: account.DockerHubKroon
      image: plugins/github-actions:0.0.3
      privileged: true
      settings:
        uses: gregkroon/buildandpushactiondocker@v1
        with:
          dockerfile: ./Dockerfile
          context: .
          image_name: munkys123/actions-golang
          username: munkys123
          password: <+secrets.getValue("account.dockerhubkroon")>
          tags: <+pipeline.sequenceId>
        env:
          GITHUB_TOKEN: <+secrets.getValue("gittoken")>
      runAsUser: "0"
      resources:
        limits:
          memory: 8G
          cpu: 2000m
```

### Step Breakdown

- **`type: Plugin`**: Identifies this step as a Drone plugin step.
- **`image`**: Specifies the image `plugins/github-actions:0.0.3` for executing the GitHub Action.
- **`privileged: true`**: Required for Docker-in-Docker operations, enabling the plugin to perform Docker builds and pushes.
- **`settings`**: The `uses` field specifies the action repository `gregkroon/buildandpushactiondocker@v1`. Key settings include:
  - `dockerfile`: Path to the Dockerfile for the build.
  - `context`: Build context (typically the root of the repository).
  - `image_name`: The name of the Docker image being pushed to DockerHub.
  - `username` and `password`: DockerHub credentials retrieved securely from Drone secrets.
  - `tags`: Uses the Drone pipeline sequence ID to tag the Docker image.
- **`env`**: Includes the `GITHUB_TOKEN`, which is required for authenticating with GitHub.
- **`resources`**: Defines resource limits for the step (8GB of memory and 2000m of CPU).

## Secrets

To use this action, you will need the following secrets configured in Drone CI:

- `account.dockerhubkroon`: Your DockerHub credentials (username and password).
- `gittoken`: GitHub personal access token for authentication.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
