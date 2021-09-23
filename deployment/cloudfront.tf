resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.website_name
}

resource "aws_cloudfront_function" "security" {
  name    = "add-security-headers"
  runtime = "cloudfront-js-1.0"
  comment = "add-security-headers"
  publish = true
  code    = file("${path.module}/js/add-security-headers.js")
}

resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.website_name
  default_root_object = var.index_document
  price_class         = var.cloudfront_price_class
  wait_for_deployment = false
  aliases             = [var.fqdn]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.website.id
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 3600
    min_ttl                = 0
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.security.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.website_name
    },
  )
}
