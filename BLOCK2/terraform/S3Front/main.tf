# S3
resource "aws_s3_bucket" "frontend_server" {
  bucket = "webapp frontend server"

  tags = {
    Name = "frontendserver"
  }
}

# ACL
resource "aws_s3_bucket_acl" "frontend_bucket_acl" {
  bucket = aws_s3_bucket.frontend_server.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "webapp_config" {
  bucket = aws_s3_bucket.frontend_server.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Versioning
resource "aws_s3_bucket_versioning" "versioning_frontend_server" {
  bucket = aws_s3_bucket.frontend_server.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Enabled"
  }
}


#########################
###### CLOUD FRONT ######
resource "aws_cloudfront_distribution" "cloud_front_dist" {
  origin {
    domain_name = aws_s3_bucket.frontend_server.website_endpoint
    origin_id   = aws_s3_bucket.frontend_server.bucket_regional_domain_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = aws_s3_bucket.frontend_server.bucket_regional_domain_name
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


##################################
############ ROUT 53 #############
resource "aws_route53_zone" "route53_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "name" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloud_front_dist.domain_name
    zone_id                = aws_cloudfront_distribution.cloud_front_dist.hosted_zone_id
    evaluate_target_health = true
  }
}
