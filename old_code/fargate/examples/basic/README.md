# Basic ECS Fargate Example

This is a basic example of how to use the ECS Fargate module to deploy a containerized application. This example is adapted to work with the existing terraform patterns used in the UDC service directories.

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Existing VPC with public and private subnets
- Subnets should be tagged with names like: `{vpc_name}-public-{az}` and `{vpc_name}-private-{az}`
- Or configure remote state data sources for VPC (see commented section in main.tf)

## Module Source Paths

The module source paths in this example use GitLab URLs pointing to the main branch:

```
git::ssh://git@gitlab.com/company/group/global-modules/fargate.git//{submodule}?ref=main
```

This allows the example to work from any directory without needing to adjust relative paths.

## Usage

1. Copy the relevant parts of this example to your terraform directory
2. Ensure you have `backend.tf` and `providers.tf` configured (these are not included in this example)
3. Update the environment-specific `*.tfvars.yml` files with your values:
   - `prod.tfvars.yml` - Production environment
   - `qa.tfvars.yml` - QA environment
   - `test.tfvars.yml` - Test environment
   - `dev.tfvars.yml` - Development environment

**Required variables to update in each environment file:**
- `project_name` - Name of your project
- `environment` - Environment name (must match the file: prod, qa, test, or dev)
- `vpc_name` - Name tag of your VPC (typically environment-specific)

**Example minimal configuration for prod.tfvars.yml:**
```yaml
project_name: my-app
environment: prod
vpc_name: my-vpc-prod
```

4. If using the Makefile pattern (converts YAML to JSON automatically), initialize and apply:

```bash
# For production
make ENV=prod init
make ENV=prod plan
make ENV=prod apply

# For QA
make ENV=qa init
make ENV=qa plan
make ENV=qa apply

# For test
make ENV=test init
make ENV=test plan
make ENV=test apply

# For development
make ENV=dev init
make ENV=dev plan
make ENV=dev apply
```

Or using Terraform directly (requires converting YAML to JSON first):

```bash
# Convert YAML to JSON (if using yq)
yq -o json eval prod.tfvars.yml > prod.tfvars.json

# Or use terraform with YAML directly (Terraform 1.0+)
terraform init
terraform workspace select prod
terraform plan -var-file=prod.tfvars.yml
terraform apply
```

**Note:** Each environment-specific `*.tfvars.yml` file contains example values. Update all values to match your environment before applying. The files are pre-configured with environment-appropriate defaults (e.g., prod has higher resources and autoscaling enabled, dev has minimal resources).

## What This Creates

- ECS Cluster
- ECS Service with Fargate launch type
- Task Definition
- Application Load Balancer
- Target Group
- Security Groups (ALB and ECS tasks)
- CloudWatch Log Group
- ECR Repository
- IAM Roles (execution and task)
- Optional Auto Scaling

## Pushing Images to ECR

After the infrastructure is created, push your Docker image:

```bash
# Get login token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Build your image
docker build -t my-app .

# Tag the image
docker tag my-app:latest <ecr-repository-url>:latest

# Push the image
docker push <ecr-repository-url>:latest
```

## Integration with Existing Patterns

This example is adapted to work with existing terraform patterns:

- **Variable naming**: Uses `project_name` and `environment` to match existing patterns
- **Tags**: Supports the same tag structure used in other UDC services
- **Image configuration**: Supports both `image` object (like Kubernetes deployments) and `container_tag` with ECR
- **Remote state**: Includes commented example for using VPC remote state (similar to `import_state.tf` pattern)
- **Region**: Supports both `region` and `aws_region` variables for compatibility

## Notes

- The example assumes your VPC subnets are tagged with specific naming conventions
- Alternatively, you can use remote state data sources (see commented section in main.tf)
- Adjust the `availability_zones` variable to match your VPC setup
- The container image must be pushed to ECR before the service can start (unless using external image repository)
- Auto scaling is disabled by default; set `enable_autoscaling = true` to enable
- Module source paths use GitLab URLs, so they work from any directory

