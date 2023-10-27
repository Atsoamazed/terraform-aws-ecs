
resource "aws_acm_certificate" "this" {
  count = var.create_route53_record ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  count = var.create_route53_record ? 1 : 0
  for_each = var.create_route53_record && var.create_alb ? { 
    for dvo in aws_acm_certificate.this[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_route53_record" "service" {
  count = var.create_route53_record ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.create_alb ? aws_alb.this[0].dns_name : null 
    zone_id                = var.create_alb ? aws_alb.this[0].zone_id : null 
    evaluate_target_health = false
  }
}
