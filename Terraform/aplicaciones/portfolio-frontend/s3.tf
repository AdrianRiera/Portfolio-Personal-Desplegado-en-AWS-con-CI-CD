# 1. Query AWS for current account number
data "aws_caller_identity" "current" {}

# 2. S3 Bucket
resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
}

# 3. Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend_crypto" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Bucket Policy (Dynamic)
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
        Condition = {
          ArnLike = {
            # Dynamically construct ARN using account ID and variable
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
          }
        }
      }
    ]
  })
}