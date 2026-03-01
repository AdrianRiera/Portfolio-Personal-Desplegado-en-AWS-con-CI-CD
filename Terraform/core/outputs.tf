# Outputs for core infrastructure

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = aws_route53_zone.principal.zone_id
}

output "route53_zone_name_servers" {
  description = "Hosted zone name servers"
  value       = aws_route53_zone.principal.name_servers
}

output "main_domain_fqdn" {
  description = "Main domain FQDN"
  value       = aws_route53_record.main_a_record.fqdn
}

output "www_domain_fqdn" {
  description = "WWW subdomain FQDN"
  value       = var.create_www_record ? aws_route53_record.www_a_record[0].fqdn : "Not created"
}

output "dns_records_summary" {
  description = "Summary of DNS records created"
  value = {
    main_domain = "${var.domain_name} → ${var.cloudfront_domain_name}"
    www_domain  = var.create_www_record ? "www.${var.domain_name} → ${var.cloudfront_domain_name}" : "Not created"
  }
}
