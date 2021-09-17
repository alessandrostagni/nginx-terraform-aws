resource "aws_s3_bucket_object" "logger" {
    bucket = aws_s3_bucket.alessandro_bucket.id
    key = "script/logger.sh"
    source = "${path.module}/script/logger.sh"
    source_hash = filemd5("${path.module}/script/logger.sh")
}

resource "aws_s3_bucket_object" "nginx-config" {
    bucket = aws_s3_bucket.alessandro_bucket.id
    key = "config/nginx.conf"
    source = "${path.module}/config/nginx.conf"
    source_hash = filemd5("${path.module}/config/nginx.conf")
}