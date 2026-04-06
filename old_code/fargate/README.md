# ECS Fargate Terraform Module

This Terraform module provides a comprehensive Amazon ECS Fargate setup with all necessary components for production-ready container deployments. It includes cluster management, services, task definitions, Application Load Balancer, logging, and auto-scaling capabilities.

## Module Structure

This is a "dry module" - a collection of reusable submodules that can be composed together:

```
fargate/
├── cluster/              # ECS cluster configuration
├── service/              # ECS service configuration
├── task-definition/      # ECS task definition
├── iam/                  # IAM roles (execution and task)
├── security-groups/      # Security groups for ALB and ECS tasks
├── logs/                 # CloudWatch log groups
├── ecr/                  # ECR repository
├── alb/                  # Application Load Balancer
├── target-group/         # ALB target group
├── autoscaling/          # Auto scaling configuration
└── examples/             # Usage examples
    └── basic/            # Basic example implementation
```

## Submodules

### Cluster (`cluster/`)

Creates an ECS cluster with Container Insights enabled.

**Inputs:**
- `cluster_name` - Name of the ECS cluster
- `tags` - Tags to apply

**Outputs:**
- `cluster_id` - Cluster ID
- `cluster_name` - Cluster name
- `cluster_arn` - Cluster ARN

### Service (`service/`)

Creates an ECS service with Fargate launch type.

**Inputs:**
- `service_name` - Name of the service
- `cluster_name` - Name of the cluster
- `task_definition_arn` - ARN of the task definition
- `desired_count` - Number of tasks to run
- `security_group_ids` - Security group IDs
- `subnet_ids` - Subnet IDs
- `target_group_arn` - (Optional) Target group ARN for load balancer
- `container_name` - (Optional) Container name for load balancer
- `container_port` - (Optional) Container port for load balancer

**Outputs:**
- `service_id` - Service ID
- `service_name` - Service name
- `service_arn` - Service ARN

### Task Definition (`task-definition/`)

Creates an ECS task definition for Fargate.

**Inputs:**
- `family` - Family name
- `execution_role_arn` - Execution role ARN
- `task_role_arn` - (Optional) Task role ARN
- `cpu` - CPU units (1024 = 1 vCPU)
- `memory` - Memory in MiB
- `container_definitions` - JSON string of container definitions

**Outputs:**
- `task_definition_arn` - Task definition ARN
- `task_definition_family` - Family name
- `task_definition_revision` - Revision number

### IAM (`iam/`)

Creates IAM roles for ECS execution and task execution.

**Inputs:**
- `execution_role_name` - Name of execution role
- `task_role_name` - (Optional) Name of task role
- `tags` - Tags to apply

**Outputs:**
- `execution_role_arn` - Execution role ARN
- `task_role_arn` - Task role ARN (if created)

### Security Groups (`security-groups/`)

Creates security groups for the load balancer and ECS tasks.

**Inputs:**
- `vpc_id` - VPC ID
- `lb_security_group_name` - Name of LB security group
- `ecs_security_group_name` - Name of ECS security group
- `app_port` - Application port
- `ingress_ports` - List of ports for LB ingress

**Outputs:**
- `lb_security_group_id` - Load balancer security group ID
- `ecs_security_group_id` - ECS tasks security group ID

### Logs (`logs/`)

Creates CloudWatch log groups.

**Inputs:**
- `log_group_name` - Name of log group
- `retention_in_days` - Log retention period

**Outputs:**
- `log_group_name` - Log group name
- `log_group_arn` - Log group ARN

### ECR (`ecr/`)

Creates an ECR repository for container images.

**Inputs:**
- `repository_name` - Repository name
- `image_tag_mutability` - Tag mutability (MUTABLE/IMMUTABLE)
- `scan_on_push` - Enable image scanning

**Outputs:**
- `repository_url` - Repository URL
- `repository_arn` - Repository ARN
- `repository_name` - Repository name

### ALB (`alb/`)

Creates an Application Load Balancer.

**Inputs:**
- `alb_name` - Name of the ALB
- `subnet_ids` - Subnet IDs
- `security_group_ids` - Security group IDs
- `internal` - Whether ALB is internal

**Outputs:**
- `alb_id` - ALB ID
- `alb_arn` - ALB ARN
- `alb_dns_name` - ALB DNS name
- `alb_zone_id` - ALB zone ID

### Target Group (`target-group/`)

Creates an ALB target group.

**Inputs:**
- `target_group_name` - Name of target group
- `vpc_id` - VPC ID
- `port` - Target port
- `health_check_path` - Health check path
- `health_check_matcher` - HTTP codes for healthy

**Outputs:**
- `target_group_arn` - Target group ARN
- `target_group_id` - Target group ID

### Autoscaling (`autoscaling/`)

Creates auto scaling configuration for ECS service.

**Inputs:**
- `service_name` - Service name
- `cluster_name` - Cluster name
- `min_capacity` - Minimum number of tasks
- `max_capacity` - Maximum number of tasks
- `cpu_target_value` - Target CPU utilization percentage (default: 70)

**Outputs:**
- `autoscaling_target_id` - Autoscaling target ID

## Usage Example

See the `examples/basic/` directory for a complete working example.

```hcl
module "cluster" {
  source = "path/to/fargate/cluster"
  
  cluster_name = "my-app-prod"
  tags = {
    Environment = "prod"
  }
}

module "iam" {
  source = "path/to/fargate/iam"
  
  execution_role_name = "my-app-execution"
  task_role_name     = "my-app-task"
}

module "service" {
  source = "path/to/fargate/service"
  
  service_name        = "my-app-service"
  cluster_name        = module.cluster.cluster_name
  task_definition_arn = module.task_definition.task_definition_arn
  security_group_ids  = [module.security_groups.ecs_security_group_id]
  subnet_ids          = var.private_subnet_ids
}
```

## Best Practices

1. **Use separate modules for each component** - This allows you to compose only what you need
2. **Tag all resources** - Use consistent tagging for cost tracking and resource management
3. **Enable Container Insights** - Already enabled in the cluster module
4. **Use private subnets** - Deploy ECS tasks in private subnets for security
5. **Enable auto scaling** - Use the autoscaling module for production workloads
6. **Secure your images** - Enable ECR image scanning
7. **Set appropriate log retention** - Balance cost vs. compliance needs

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0
- Existing VPC with subnets

## Notes

- This module uses Fargate launch type only
- Container definitions must be provided as JSON strings
- The module does not create ALB listeners - you'll need to create those separately or use a listener module
- Task role is optional - only create if your application needs AWS API access

## Contributing

When modifying this module:

1. Test changes in a non-production environment
2. Update documentation for any new variables or outputs
3. Follow Terraform best practices
4. Maintain backward compatibility where possible

