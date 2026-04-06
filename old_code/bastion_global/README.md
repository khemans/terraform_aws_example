# Bastion Global
This module was designed to deploy a Bastion host wherever it is needed, just by adding the example files to an existing repo. This also includes a user_data file that will build a script to query Gitlab for it's members and update the appropiate 'authorized_keys' file to allow member access to ssh into the bastion host. 


## Getting started
1. Copy the files from the examples folder to the desired repo.
    a. If this lives higher than the app code, you will need to add additional files to independantly run a pipeline
2. Create or edit the .tfvars.yml file to fill in the appropiate information.
3. Create an MR in your local repo to allow Terraform to plan.
    a. Verify the bastion host will get created as expected
4. Merge your branch to 'main' to execute Terraform apply

## Configure Terraform and Gitlab
1. If creating at the top level of a project, create a new project in the target repos. If not proceed to step 2.
2. Copy example directory terraform files from: https://gitlab.com/remaxllc/cloud-infrastructure/global-modules/bastion_global
3. Paste into target repos
4. Remove files, if they exist: ENV.tfvars.json, ENV-bucket.conf, .terraform.lock.hcl, .terraform (directory)
5. Create gitlab variables at the sub-group level containing the Bastion repos. Add the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY you created for user 'gitlab' in step 3 of AWS account setup
6. IMPORTANT! Make sure to fill in the "Environments" field in the gitlab variable to match the environment that's being deployed. This should match the terraform workspace name as well. Either 'nonprod' or 'prod'

## Update Terraform
1. Update the nonprod.tfvars.yml and prod.tfvars.yml files with environment-specific values.
    - IMPORTANT! Before running terraform for the first time; you must, at minimum update the bucket_name (for the statefile) and the roles and users that will be permissioned to the Bastion host.
2. The bucket name should be the same as the VPC state bucket. This is a requirement to pull the remote_state data.

## Makefile
If you are adding this to the top level of the project, this step is required. You should not need to edit the makefile.

Common Makefile commands. Use prod or nonprod as the ENV= value:
- make ENV=nonprod plan
    - This will run a terraform init which also created a temporary env-bucket.conf file which is used to target the proper statefile backed S3 bucket.
- make ENV=nonprod apply
- make ENV=nonprod plan-destroy
- make ENV=nonprod destroy

