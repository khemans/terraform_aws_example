output "s3_bucket_id" {
  value = module.static_bucket.bucket_id
}

output "cloudfront_domain" {
  value = module.cdn.distribution_domain_name
}

output "cloudfront_distribution_id" {
  value = module.cdn.distribution_id
}
