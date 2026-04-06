#########
#  WIP  #
#########

resource "aws_ssoadmin_permission_set" "secops-lead" {
  name             = "secops-lead"
  description      = "Allows read access to encrypted S3 logs and Athena query capability"
  instance_arn     = var.instance_arn
  session_duration = "PT1H"
}

data "aws_iam_policy_document" "secops-lead" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "arn:aws:kms:us-east-1:<account-id>:key/<kms-key-id>"
    ]
  }

  statement {
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "glue:GetDatabase",
      "glue:GetTable",
      "glue:GetPartition"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetDashboard" # Optional: if they need to view CloudWatch Dashboards
    ]
    resources = ["*"] # CloudWatch permissions are generally service-level
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "secops-lead" {
  inline_policy      = data.aws_iam_policy_document.secops-lead.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.secops-lead.arn
}


