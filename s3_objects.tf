resource "aws_s3_bucket_object" "logger" {
    bucket = aws_s3_bucket.alessandro_bucket.id
    key = "script/logger.py"
    source = "${path.module}/script/logger.py"
    source_hash = filemd5("${path.module}/script/logger.py")
}

resource "aws_s3_bucket_object" "nginx-config" {
    bucket = aws_s3_bucket.alessandro_bucket.id
    key = "config/logger.py"
    source = "${path.module}/config/nginx.conf"
    source_hash = filemd5("${path.module}/config/nginx.conf")
}