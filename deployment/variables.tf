variable "aws_profile" {
  description = "The AWS profile to deploy the site"
  default     = "david74"
}

variable "region" {
  description = "The region to create the S3 bucket and other resources."
  default     = "ap-northeast-1"
}

variable "website_name" {
  description = "The name of this static website; also for S3 bucket"
  default     = "david74-resume"
}

variable "tags" {
  description = "Tags"
  default = {
    Purpose     = "resume"
    Environment = "production"
  }
}

# Domain name
variable "fqdn" {
  description = "The fully-qualified domain name of the resulting S3 website."
  default     = "me.david74.dev"
}

variable "domain" {
  description = "The domain name of this website"
  default     = "david74.dev"
}

variable "index_document" {
  description = "HTML to show at root"
  default     = "index.html"
}

variable "cloudfront_price_class" {
  description = "The price class for Cloudfront"
  default     = "PriceClass_200"
}
