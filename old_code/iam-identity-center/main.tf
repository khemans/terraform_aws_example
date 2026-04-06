data "aws_ssoadmin_instances" "current" {}
data "aws_caller_identity" "current" {}

locals {
  instance_arn = tolist(data.aws_ssoadmin_instances.current.arns)[0]
}

module "permission_sets_us" {
count = local.instance_arn == "arn:aws:sso:::instance/<us-sso-instance-id>" ? 1 : 0  
  source = "./permission-sets/US"
  instance_arn = local.instance_arn
  # bucket_name = "terraform-aws-admin-primary"
  # account_id = data.aws_caller_identity.current.account_id
}

module "permission_sets_ca" {
count = local.instance_arn == "arn:aws:sso:::instance/<ca-sso-instance-id>" ? 1 : 0  
  source = "./permission-sets/CA"
  instance_arn = local.instance_arn
  # bucket_name = "terraform-aws-admin-primary"
  # account_id = data.aws_caller_identity.current.account_id
}