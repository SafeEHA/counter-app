#!/bin/bash

# Set your project ID and service account key file path
PROJECT_ID="bold-listener-320807"
KEY_FILE="/Users/user/Downloads/bold-listener-320807.json"

# Set the path to your source code and Dockerfile
REPO_URL="https://github.com/SafeEHA/counter-app.git"
git clone $REPO_URL
cd /counter-app

# Authenticate with Google Cloud
gcloud auth activate-service-account --key-file="$KEY_FILE" 
gcloud config set $PROJECT_ID

# Trigger Cloud Build
gcloud builds submit --config="cloudbuild.yml" "$DOCKERFILE_PATH" "$SOURCE_PATH"
