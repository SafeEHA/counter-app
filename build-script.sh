#!/bin/bash

# Set your project ID and service account key file path
PROJECT_ID="safes-project"
KEY_FILE="/Users/user/Downloads/safes-project-be8f945e8574.json"
BUCKET_NAME="artifacts.safes-project.appspot.com"

# Set the path to your source code and Dockerfile
REPO_URL="https://github.com/SafeEHA/counter-app.git"

# Clone the repository
# git clone $REPO_URL
cd counter-app

# Authenticate with Google Cloud
gcloud auth activate-service-account --key-file=$KEY_FILE
gcloud config set project $PROJECT_ID

# Access token
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Copy source code to GCS
BUCKET_DIRECTORY="sourcecode"
LOCAL_FILE_PATH="."
ZIP_FILE="counter-app.zip"
BUILD_ID=$(gcloud builds list --limit=1 --format="value(ID)")

# Remove any existing files in the GCS bucket directory
gsutil -m rm -r "gs://${BUCKET_NAME}/${BUCKET_DIRECTORY}/**"

# Copy the source code to GCS
gsutil cp "${ZIP_FILE}" "gs://${BUCKET_NAME}/${BUCKET_DIRECTORY}/"

# Trigger Cloud Build
curl -s -X POST https://cloudbuild.googleapis.com/v1/projects/safes-project/builds?alt=json \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-type: application/json" \
  -d '{
    "source": {
      "storageSource": {
        "bucket": "artifacts.safes-project.appspot.com",
        "object": "sourcecode/counter-app.zip"
      }
    },
    "timeout": "1200s",
    "steps": [
        {
            "name": "gcr.io/cloud-builders/docker",
            "args": ["build", "-t", "gcr.io/safes-project/my-image:latest", "./counter-app"],

        },
        {
            "name": "gcr.io/cloud-builders/docker",
            "args": ["push", "gcr.io/safes-project/my-image:latest"]

        },
        {
            "name": "gcr.io/cloud-builders/gcloud",
            "args": [
              "run",
              "deploy",
              "my-cloudrun-service",
              "--image=gcr.io/safes-project/my-image:latest",
              "--platform=managed",
              "--region=us-east1",
              "--port=80"
            ]
              
        }
    ],
    "images": ["gcr.io/safes-project/my-image"]

 }' 
    # Get build information from Cloud Build API
    BUILD_INFO=$(curl -s -H "Authorization: Bearer ${ACCESS_TOKEN}", "https://cloudbuild.googleapis.com/v1/projects/${PROJECT_ID}/builds/${BUILD_ID}")


    # Extract artifact URL from the build results
    ARTIFACT_URL=$(echo "$BUILD_INFO" | jq ".artifacts.images[0]")
        
    # Print the artifact URL
    echo "Container Artifact URL: ${ARTIFACT_URL}"