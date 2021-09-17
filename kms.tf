resource "aws_kms_key" "alessandro_bucket_key" {
  description             = "Key for encrypting the nginx-alessandro-stagni bucket."
  deletion_window_in_days = 10
}