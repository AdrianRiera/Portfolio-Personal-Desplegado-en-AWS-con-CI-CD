variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  type        = string
}

variable "acm_certificate_arn" {
  description = "SSL certificate ARN in us-east-1"
  type        = string
}

variable "oac_name" {
  description = "Origin Access Control name"
  type        = string
}

variable "domain_aliases" {
  description = "List of domain aliases for CloudFront"
  type        = list(string)
}

variable "origin_id" {
  description = "Origin ID for CloudFront distribution"
  type        = string
}

variable "cache_policy_id" {
  description = "AWS Cache Policy ID"
  type        = string
  default     = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_All"
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "distribution_comment" {
  description = "CloudFront distribution comment"
  type        = string
}

variable "minimum_protocol_version" {
  description = "Minimum TLS protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "cloudfront_tag_name" {
  description = "Name tag for CloudFront"
  type        = string
}
