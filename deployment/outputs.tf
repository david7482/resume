output "s3_website_bucket" {
  value = aws_s3_bucket.website.bucket
}

output "website_domain_name" {
  value = "https://${var.fqdn}"
}