resource "aws_s3_bucket" "alessandro_bucket" {
    bucket = "nginx.alessandro.stagni"
    acl = "private"
    tags = {
        Name = "nginx-alessandro-stagni"
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = aws_kms_key.alessandro_bucket_key.arn
                sse_algorithm     = "aws:kms"
            }
        }
    }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_configuration" {
    bucket = aws_s3_bucket.alessandro_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "alessandro_bucket_policy" {
    bucket = aws_s3_bucket.alessandro_bucket.id

    # Terraform's "jsonencode" function converts a
    # Terraform expression's result to valid JSON syntax.
    policy = jsonencode({
        Version = "2012-10-17",
        Id      = "AlessandroBucketPolicy",
        Statement = {
        Effect = "Allow",
        Principal = {
            "AWS": aws_iam_role.alessandro_instance_role.arn
        },
        "Action" = "s3:GetObject",
        "Resource" = "${aws_s3_bucket.alessandro_bucket.arn}/*"
        }
    })
}