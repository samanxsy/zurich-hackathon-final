# S3
resource "aws_s3_bucket" "image_bucket" {
    bucket = "damaged-vehicles-images"

    tags = {
        Name = "Damaged Vehicles"
    }
}

# ACL
resource "aws_s3_bucket_acl" "bucket_acl" {
    bucket = aws_s3_bucket.image_bucket.id
    acl = "private"
}

# Versioning
resource "aws_s3_bucket_versioning" "versioning_image_bucket" {
    bucket = aws_s3_bucket.image_bucket.id

    versioning_configuration {
      status = "Enabled"
      mfa_delete = "Enabled"
    }
}

# Logging
resource "aws_s3_bucket_logging" "image_bucket_logging" {
    bucket = aws_s3_bucket.image_bucket.id

    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
}

# LifeCycle
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
    bucket = aws_s3_bucket.image_bucket.id

    rule {
        id = "Archiving"
        status = "Enabled"
        transition {
            days = 360
            storage_class = "GLACIER"
        }

        transition {
            days = 720
            storage_class = "DEEP_ARCHIVE"
        }  
    }
}

resource "aws_kms_key" "kms_key" {
    description = "KMS KEY"
    enable_key_rotation = true
    # deletion_window_in_days = 20
}

# SERVER SIDE ENCRYPTION
resource "aws_s3_bucket_server_side_encryption_configuration" "name" {
    bucket = aws_s3_bucket.image_bucket.id

    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key.arn
        sse_algorithm = "aws:kms"
      }
    }
}

############### LOG BUCKET #################
resource "aws_s3_bucket" "log_bucket" {
    bucket = "log-bucket"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
    bucket = aws_s3_bucket.log_bucket.id
    acl = "log-delivery-write"
}
