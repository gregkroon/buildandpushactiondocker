# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Install Docker CLI and bash
RUN apt-get update && apt-get install -y \
    docker.io \
    bash \
    curl

# Copy the shell script into the container
COPY main.sh /main.sh

# Make sure the script is executable
RUN chmod +x /main.sh

# Define the entrypoint for the action to run the shell script
ENTRYPOINT ["/main.sh"]
