resource "aws_ssoadmin_permission_set" "dev-lead" {
  name             = "company-dev-lead"
  description      = "Company Developer PowerUser"
  instance_arn     = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "dev-lead" {
  statement {
    effect = "Allow"
    not_actions = [
				"organizations:*",
				"account:*",
				"aws-portal:*",
        "iam:CreateUser"
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
      "organizations:DescribeOrganization"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "dev-lead" {
  inline_policy      = data.aws_iam_policy_document.dev-lead.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dev-lead.arn
}