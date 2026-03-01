resource "aws_route53_zone" "principal" {
  name    = var.domain_name
  comment = var.zone_comment
}

# 1. A Record (Main domain pointing to CloudFront)
resource "aws_route53_record" "main_a_record" {
  zone_id = aws_route53_zone.principal.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2" # Fixed, this is CloudFront's global zone ID
    evaluate_target_health = var.evaluate_target_health
  }
}

# 2. CNAME Record (ACM certificate validation)
resource "aws_route53_record" "main_cert_validation" {
  zone_id = aws_route53_zone.principal.zone_id
  name    = "${var.acm_validation_prefix}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.acm_validation_target]
}

# 3. A Record for www (Subdomain pointing to CloudFront)
resource "aws_route53_record" "www_a_record" {
  count   = var.create_www_record ? 1 : 0
  zone_id = aws_route53_zone.principal.zone_id
  name    = "${var.www_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront global zone ID
    evaluate_target_health = var.evaluate_target_health
  }
}