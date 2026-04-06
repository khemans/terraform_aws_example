resource "aws_ssoadmin_permission_set" "dns-admin" {
  name         = "company-dns-admin"
  description      = "Company DNS administration"
  instance_arn = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "dns-admin" {
  statement {
    effect = "Allow"
    actions = [
      "route53:*",
      "route53domains:*"
    ]
    resources = [
      "*",
    ]
  }

# Deny access
  statement {
    effect = "Allow"
    not_actions = [
				"*"
			]
    resources = [
      "*"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "dns-admin" {
  inline_policy      = data.aws_iam_policy_document.dns-admin.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dns-admin.arn
}