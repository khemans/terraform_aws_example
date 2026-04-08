# Development Environment Deployment

## Introduction

This repository was created for demo purposes for my interview with Charter Communications. It showcases Terraform infrastructure code, based on my previous experiences and deployment methods I've used in the past. The `old_code` directory contains code from my previous employment that I have available.

This directory contains the Terraform configuration for the development environment of the platform.

## Prerequisites
- Terraform installed
- AWS credentials configured
- yq installed (for Makefile method)

## Method 1: Local Terraform Apply

1. Navigate to the dev directory:
   ```
   cd environments/dev
   ```

2. Generate the backend configuration file:
   ```
   echo 'bucket="platform-dev-env-tfstate"' > dev-bucket.conf
   ```

3. Initialize Terraform:
   ```
   terraform init -backend-config=./dev-bucket.conf
   ```

4. Select or create the workspace:
   ```
   terraform workspace select dev || terraform workspace new dev
   ```

5. Plan the deployment:
   ```
   terraform plan -var-file dev.tfvars
   ```

6. Apply the changes:
   ```
   terraform apply -var-file dev.tfvars
   ```

## Method 2: Makefile Deployment

1. Set the environment variable:
   ```
   export ENV=dev
   ```

2. Navigate to the dev directory:
   ```
   cd environments/dev
   ```

3. Initialize and generate backend config:
   ```
   make init
   ```

4. Create the plan:
   ```
   make plan
   ```

5. Apply the plan:
   ```
   make apply
   ```

Note: The Makefile automatically converts `dev.tfvars.yml` to `dev.tfvars.json` and uses it for planning and applying. The backend bucket name is extracted from the YAML file.