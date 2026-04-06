resource "aws_ssoadmin_permission_set" "ebi-dev" {
  name         = "company-ebi-dev-team"
  description      = "Company EBI developer restricted access to S3"
  instance_arn = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "ebi-dev" {
  statement {

# Setting a principal to restrict policy scope to EBI account only
    # principals {
    #   type = "AWS"
    #   identifiers = ["arn:aws:s3:::*"]
    # }
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    effect = "Allow"
    not_actions = [
      "organizations:*",
      "account:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "ebi-dev" {
  inline_policy      = data.aws_iam_policy_document.ebi-dev.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.ebi-dev.arn
}