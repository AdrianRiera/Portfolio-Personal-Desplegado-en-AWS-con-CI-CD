# Outputs for portfolio-frontend

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.frontend.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.frontend.arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.frontend.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_status" {
  description = "CloudFront distribution status"
  value       = aws_cloudfront_distribution.frontend.status
}

output "cloudfront_aliases" {
  description = "CloudFront configured aliases"
  value       = aws_cloudfront_distribution.frontend.aliases
}

output "infrastructure_summary" {
  description = "Infrastructure summary"
  value = {
    s3_bucket         = aws_s3_bucket.frontend.id
    cloudfront_domain = aws_cloudfront_distribution.frontend.domain_name
    custom_domains    = join(", ", aws_cloudfront_distribution.frontend.aliases)
    cloudfront_status = aws_cloudfront_distribution.frontend.status
  }
}
