terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.20"
    }
  }

  backend "s3" {
    bucket         = ""
    key            = ""
    region         = "us-east-1"
    use_lockfile   = true
    #dynamodb_table = "terraform_lock"
    #primary key: LockID
  }
}
