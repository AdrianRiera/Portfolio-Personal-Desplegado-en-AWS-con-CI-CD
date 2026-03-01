# Portfolio Frontend Infrastructure

This module manages the infrastructure for the portfolio frontend using S3 and CloudFront.

## Created Resources

- **S3 Bucket**: Storage for static files
- **S3 Bucket Encryption**: AES256 encryption
- **S3 Bucket Policy**: Allows access only from CloudFront
- **CloudFront OAC**: Origin Access Control for security
- **CloudFront Distribution**: CDN for global distribution

## Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| bucket_name | S3 bucket name | string | - | Yes |
| cloudfront_distribution_id | CloudFront distribution ID | string | - | Yes |
| acm_certificate_arn | SSL certificate ARN | string | - | Yes |
| oac_name | Origin Access Control name | string | - | Yes |
| domain_aliases | Custom domain list | list(string) | - | Yes |
| origin_id | CloudFront Origin ID | string | - | Yes |
| cache_policy_id | Cache policy ID | string | CachingOptimized | No |
| price_class | CloudFront price class | string | PriceClass_All | No |
| default_root_object | Default root object | string | index.html | No |
| distribution_comment | Distribution comment | string | - | Yes |
| minimum_protocol_version | Minimum TLS version | string | TLSv1.2_2021 | No |
| cloudfront_tag_name | Name tag for CloudFront | string | - | Yes |

## Outputs

- `s3_bucket_name`: S3 bucket name
- `s3_bucket_arn`: S3 bucket ARN
- `cloudfront_distribution_id`: CloudFront ID
- `cloudfront_distribution_arn`: CloudFront ARN
- `cloudfront_domain_name`: CloudFront domain name
- `cloudfront_status`: Distribution status
- `cloudfront_aliases`: Configured aliases
- `infrastructure_summary`: Complete summary

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

## File Deployment

After creating the infrastructure, you can upload files to the bucket:

```bash
aws s3 sync ./dist s3://portfolio-adrian-prod --delete
```

Then invalidate the CloudFront cache:

```bash
aws cloudfront create-invalidation --distribution-id EA81JWYSFP9LI --paths "/*"
```

## Implemented Best Practices

- ✅ Origin Access Control (OAC) instead of OAI (legacy)
- ✅ Forced HTTPS (redirect-to-https)
- ✅ Compression enabled
- ✅ S3 encryption at rest
- ✅ Restrictive S3 policy (CloudFront only)
- ✅ Custom SSL/TLS certificate
- ✅ HTTP/2 enabled
- ✅ Parameterized variables
- ✅ AWS Cache Policy (optimized)
- ✅ Informative outputs

## Security

- The S3 bucket is NOT public
- Only CloudFront can access the bucket (using OAC)
- HTTPS traffic forced
- Minimum TLS 1.2+
- AES256 encryption in S3

## Important Notes

- The OAC name and origin_id must match the values in AWS if you import existing resources
- The Cache Policy ID `658327ea-f89d-4fab-a63d-7e88639e58f6` is AWS's "CachingOptimized" policy
- Aliases must also be configured in Route53
- The ACM certificate must be in us-east-1 (required by CloudFront)
