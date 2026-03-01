# Core Infrastructure - Route53

This module manages the core DNS infrastructure using AWS Route53.

## Created Resources

- **Route53 Hosted Zone**: Hosted zone for the main domain
- **A Record (main domain)**: Points to CloudFront using alias
- **A Record (www subdomain)**: Points to CloudFront using alias
- **CNAME Record**: For ACM certificate validation

## Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| domain_name | Main domain | string | - | Yes |
| zone_comment | Comment for the zone | string | - | Yes |
| cloudfront_domain_name | CloudFront domain name | string | - | Yes |
| evaluate_target_health | Evaluate target health | bool | false | No |
| acm_validation_prefix | ACM validation prefix | string | - | Yes |
| acm_validation_target | ACM validation target | string | - | Yes |
| www_subdomain | WWW subdomain name | string | "www" | No |
| create_www_record | Create www record | bool | true | No |

## Outputs

- `route53_zone_id`: Route53 zone ID
- `route53_zone_name_servers`: Zone name servers
- `main_domain_fqdn`: Main domain FQDN
- `www_domain_fqdn`: WWW subdomain FQDN
- `dns_records_summary`: DNS records summary

## Usage

1. Configure variables in `terraform.tfvars`
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review changes:
   ```bash
   terraform plan
   ```
4. Apply changes:
   ```bash
   terraform apply
   ```

## Implemented Best Practices

- ✅ Use of variables for flexibility
- ✅ Sensible default values
- ✅ ALIAS records instead of CNAME for root domains
- ✅ Conditional resource creation (www)
- ✅ Descriptive outputs
- ✅ Clear code comments
- ✅ Hardcoded CloudFront Zone ID (it's global and never changes)

## Notes

- The Zone ID `Z2FDTNDATAQYW2` is the global CloudFront ID and never changes
- A records use ALIAS for better performance and no cost
- The www subdomain is optional and can be disabled with `create_www_record = false`
