resource "aws_ssoadmin_permission_set" "company-developer" {
  name         = "company-developer"
  description      = "Company Developer"
  instance_arn = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "company-developer" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }

# Deny access to EBI S3 Buckets
  statement {
    # principals {
    #   type = "AWS"
    #   identifiers = ["846825045253"]
    # }
    effect = "Allow"
    not_actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3::<ebi-account-id>:*"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "company-developer" {
  inline_policy      = data.aws_iam_policy_document.company-developer.json
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.company-developer.arn
}