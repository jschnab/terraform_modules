resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "a_no_www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.web_lb.dns_name
    zone_id                = aws_lb.web_lb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "a_www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.web_lb.dns_name
    zone_id                = aws_lb.web_lb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "certif" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "certif_valid_0" {
  name    = aws_acm_certificate.certif.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.certif.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.main.id
  records = [aws_acm_certificate.certif.domain_validation_options.0.resource_record_value]
  ttl     = 300
}

resource "aws_route53_record" "certif_valid_1" {
  name    = aws_acm_certificate.certif.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.certif.domain_validation_options.1.resource_record_type
  zone_id = aws_route53_zone.main.id
  records = [aws_acm_certificate.certif.domain_validation_options.1.resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "valid" {
  certificate_arn = aws_acm_certificate.certif.arn

  validation_record_fqdns = [
    aws_route53_record.certif_valid_0.fqdn,
    aws_route53_record.certif_valid_1.fqdn,
  ]
}
