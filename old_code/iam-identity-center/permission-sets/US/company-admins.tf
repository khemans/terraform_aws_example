resource "aws_ssoadmin_permission_set" "aws-admins" {
  name         = "company-aws-admins"
  description      = "Company Administrators"
  instance_arn = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "aws-admins" {
  statement {

    actions = [
      "*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "aws-admins" {
  inline_policy      = data.aws_iam_policy_document.aws-admins.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.aws-admins.arn
}