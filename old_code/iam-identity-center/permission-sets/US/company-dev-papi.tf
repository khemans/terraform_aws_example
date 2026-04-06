resource "aws_ssoadmin_permission_set" "dev-papi" {
  name         = "company-dev-papi"
  description      = "Company Developer PAPI no S3 allowed"
  instance_arn = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "dev-papi" {
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

resource "aws_ssoadmin_permission_set_inline_policy" "dev-papi" {
  inline_policy      = data.aws_iam_policy_document.dev-papi.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dev-papi.arn
}