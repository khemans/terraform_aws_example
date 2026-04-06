# Terraform practice (AWS)

Dehydrated root modules under `modules/` compose into smaller **examples** and full **live** stacks. Region, naming, and tags are driven by variables so you can reuse the same code for multiple services and environments.

## Layout

| Path | Purpose |
|------|---------|
| `modules/` | Reusable building blocks (VPC, S3, CloudFront+S3 OAC, bastion, Aurora PostgreSQL Serverless v2, ElastiCache Redis, EKS) |
| `examples/` | Focused compositions (static site, data tier, EKS + bastion) — each includes `dev.tfvars` and `prod.tfvars` |
| `live/dev`, `live/prod` | Full-stack roots (separate state per directory) with both tfvars files for comparisons |

## Without an AWS account

- `terraform init` and `terraform validate` do **not** need credentials.
- `terraform plan` and `apply` need valid AWS credentials and typically cost money (EKS, Aurora, NAT, etc.).

Example workflow from any root (example or live):

```bash
terraform init
terraform validate
terraform plan -var-file=dev.tfvars
```

Use `prod.tfvars` where you want to rehearse prod-shaped values.

## Interview notes

- **Modules**: show inputs/outputs, security groups, and how examples wire multiple services.
- **Promotion**: compare `dev.tfvars` vs `prod.tfvars` (CIDRs, SSH CIDR, tags).
- **State**: each `live/dev` and `live/prod` folder is its own root — use separate backends when you have an account (S3 + DynamoDB lock).

## Remote state (optional)

When you have an account, add a `backend "s3" { ... }` block in a `versions.tf` or `backend.tf` per environment (do not commit bucket names if they are sensitive).
