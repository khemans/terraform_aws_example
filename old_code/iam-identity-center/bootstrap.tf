resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-aws-admin-primary-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "terraform_state_us" {
  count = local.instance_arn == "arn:aws:sso:::instance/<us-sso-instance-id>" ? 1 : 0
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_ca" {
  count = local.instance_arn == "arn:aws:sso:::instance/<ca-sso-instance-id>" ? 1 : 0
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
       sse_algorithm     = "AES256"
  }
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform_lock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
