resource "aws_s3_bucket" "alessandro_bucket" {
    bucket = "nginx.alessandro.stagni"
    acl = "private"
    tags = {
        Name = "nginx-alessandro-stagni"
    }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_configuration" {
    bucket = aws_s3_bucket.alessandro_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}