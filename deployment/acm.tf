resource "aws_acm_certificate" "cert" {
  provider          = aws.us-east-1
  domain_name       = var.fqdn
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      "Name" = var.website_name
    },
  )
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  provider = aws.us-east-1
  name     = each.value.name
  type     = each.value.type
  records  = [each.value.record]
  zone_id  = data.aws_route53_zone.main.id
  ttl      = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}