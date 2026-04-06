resource "random_id" "bucket_suffix" {
  byte_length = 4
}

module "static_bucket" {
  source = "../../modules/s3_bucket"

  project_name    = var.project_name
  environment     = var.environment
  bucket_suffix   = random_id.bucket_suffix.hex
  enable_versioning = true
  tags            = var.extra_tags
}

module "cdn" {
  source = "../../modules/cloudfront_s3"

  project_name                   = var.project_name
  environment                    = var.environment
  s3_bucket_id                   = module.static_bucket.bucket_id
  s3_bucket_arn                  = module.static_bucket.bucket_arn
  s3_bucket_regional_domain_name = module.static_bucket.bucket_domain_name
  default_root_object            = "index.html"
  tags                           = var.extra_tags
}
