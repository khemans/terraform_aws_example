# Production Environment Deployment

## Introduction

This repository was created for demo purposes for my interview with Charter Communications. It showcases Terraform infrastructure code, based on my previous experiences and deployment methods I've used in the past. The `old_code` directory contains code from my previous employment that I have available.

This directory contains the Terraform configuration for the production environment of the platform.

## Prerequisites
- Terraform installed
- AWS credentials configured
- yq installed (for Makefile method)

## Method 1: Local Terraform Apply

1. Navigate to the prod directory:
   ```
   cd environments/prod
   ```

2. Generate the backend configuration file:
   ```
   echo 'bucket="platform-prod-env-tfstate"' > prod-bucket.conf
   ```

3. Initialize Terraform:
   ```
   terraform init -backend-config=./prod-bucket.conf
   ```

4. Select or create the workspace:
   ```
   terraform workspace select prod || terraform workspace new prod
   ```

5. Plan the deployment:
   ```
   terraform plan -var-file prod.tfvars
   ```

6. Apply the changes:
   ```
   terraform apply -var-file prod.tfvars
   ```

## Method 2: Makefile Deployment

1. Set the environment variable:
   ```
   export ENV=prod
   ```

2. Navigate to the prod directory:
   ```
   cd environments/prod
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

Note: The Makefile automatically converts `prod.tfvars.yml` to `prod.tfvars.json` and uses it for planning and applying. The backend bucket name is extracted from the YAML file.