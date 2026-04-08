resource "aws_ssoadmin_permission_set" "dev-api" {
  name         = "company-dev-api"
  description      = "Company Developer api no S3 allowed"
  instance_arn = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "dev-api" {
  statement {
    effect = "Allow"
    not_actions = [
				"iam:*",
				"organizations:*",
				"account:*",
				"s3:*",
				"aws-portal:*"
			]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "account:GetAccountInformation",
      "account:GetPrimaryEmail",
      "account:ListRegions",
      "cloudwatch:*",
      "iam:CreateServiceLinkedRole",
      "iam:DeleteServiceLinkedRole",
      "iam:ListRoles",
      "organizations:DescribeOrganization"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "dev-api" {
  inline_policy      = data.aws_iam_policy_document.dev-api.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dev-api.arn
}