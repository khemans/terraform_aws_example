# IAM Identity Center - Multi-Organization Terraform Configuration

This repository contains Terraform configuration for managing AWS IAM Identity Center (SSO) across multiple organizations - Company US and Company Canada. The configuration automatically detects which SSO instance is being used and applies the appropriate permission sets.

## Architecture Overview

This Terraform configuration uses a unique conditional approach to manage two separate SSO organizations:

- **Company US SSO**: `arn:aws:sso:::instance/<us-sso-instance-id>`
- **Company Canada SSO**: `arn:aws:sso:::instance/<ca-sso-instance-id>`

The configuration automatically detects the current SSO instance and only applies the relevant permission sets for that organization.

## Prerequisites

1. **AWS CLI configured with SSO access**
2. **Terraform >= 1.0**
3. **AWS Provider >= 5.20**
4. **Access to both Company US and Canada SSO instances**

## Setup Instructions

### 1. Configure AWS SSO Access

Ensure you have access to both SSO organizations using the multi-SSO setup:

```bash
# Login to Company US SSO
aws sso login --sso-session default

# Login to Company Canada SSO  
aws sso login --sso-session canada
```

### 2. Bootstrap Infrastructure (First Time Only)

Before running Terraform, you need to bootstrap the S3 backend and DynamoDB lock table:

```bash
# Switch to the appropriate account (Company US Primary)
assume company-primary

# Initialize with US backend configuration
terraform init -backend-config=backend.conf

# Apply bootstrap configuration
terraform apply -target=aws_s3_bucket.terraform_state
terraform apply -target=aws_dynamodb_table.terraform_lock
```

### 3. Configure Backend

The configuration uses different S3 backends for each organization. Use the `-backend-config=` flag to specify the appropriate backend:

#### For Company US Organization:
```bash
terraform init -backend-config=backend.conf
```

#### For Company Canada Organization:
```bash
terraform init -backend-config=backend-ca.conf
```

### 4. Deploy Permission Sets

#### For Company US Organization:
```bash
assume company-primary
terraform init -backend-config=backend.conf
terraform plan
terraform apply
```

#### For Company Canada Organization:
```bash
assume company-integra-primary
terraform init -backend-config=backend-ca.conf
terraform plan
terraform apply
```

## Directory Structure

```
iam-identity-center/
├── main.tf                    # Main configuration with conditional modules
├── bootstrap.tf               # S3 backend and DynamoDB lock table
├── backend.tf                 # Terraform backend configuration
├── backend.conf               # US-specific backend configuration
├── backend-ca.conf            # Canada-specific backend configuration
├── variables.tf               # Global variables
├── permission-sets/
│   ├── US/                   # US-specific permission sets
│   │   ├── company-admins.tf
│   │   ├── company-dev-lead.tf
│   │   ├── company-dev-papi.tf
│   │   ├── company-dev-standard.tf
│   │   ├── company-developer.tf
│   │   ├── company-dns-admin.tf
│   │   ├── ebi-team-developer.tf
│   │   ├── secops-lead.tf
│   │   ├── security-analyst.tf
│   │   └── variables.tf
│   └── CA/                   # Canada-specific permission sets
│       ├── canada-lead.tf
│       ├── canada-dev.tf
│       └── variables.tf
└── README.md
```

## Key Features

### Conditional Module Loading
The configuration uses Terraform's `count` parameter to conditionally load modules based on the detected SSO instance:

```hcl
module "permission_sets_us" {
  count = local.instance_arn == "arn:aws:sso:::instance/<us-sso-instance-id>" ? 1 : 0  
  source = "./permission-sets/US"
  instance_arn = local.instance_arn
}

module "permission_sets_ca" {
  count = local.instance_arn == "arn:aws:sso:::instance/<ca-sso-instance-id>" ? 1 : 0  
  source = "./permission-sets/CA"
  instance_arn = local.instance_arn
}
```

### State Management
- **US Organization**: Uses S3 bucket `terraform-aws-admin-primary-<us-account-id>` in `us-west-2` region
- **Canada Organization**: Uses S3 bucket `terraform-aws-admin-primary-<ca-account-id>` in `us-east-1` region
- **Lock Table**: Shared DynamoDB table `terraform_lock`

## Available Permission Sets

### Company US Organization
- `company-aws-admins` - Full administrative access
- `company-dev-lead` - Development team lead permissions
- `company-dev-papi` - PAPI-specific development permissions
- `company-dev-standard` - Standard development permissions
- `company-developer` - General development permissions
- `company-dns-admin` - DNS management permissions
- `company-ebi-dev-team` - EBI team development permissions
- `secops-lead` - Security operations lead permissions
- `security-analyst` - Security analysis permissions

### Company Canada Organization
- `CA-Lead` - Canada team lead permissions
- `CA-Developer` - Standard Canada team permissions

## Troubleshooting

### Common Issues

1. **Wrong SSO Instance**: Ensure you're logged into the correct SSO organization
2. **Backend Configuration**: Always use `-backend-config=backend.conf` for US and `-backend-config=backend-ca.conf` for Canada
3. **State Lock**: If you encounter state lock issues, check the DynamoDB table
4. **Backend Mismatch**: If you get backend errors, reinitialize with the correct backend config

### Verification Commands

```bash
# Check current SSO instance
aws sso-admin list-instances

# Verify current identity
aws sts get-caller-identity

# List available profiles
aws configure list-profiles
```

## Contributing

When adding new permission sets:

1. **US Organization**: Add files to `permission-sets/US/`
2. **Canada Organization**: Add files to `permission-sets/CA/`
3. Follow the existing naming convention
4. Update this README with new permission set descriptions

## Security Notes

- All permission sets include appropriate least-privilege access
- Inline policies are used for fine-grained control
- State files are encrypted at rest in S3
- DynamoDB provides state locking for concurrent operations
