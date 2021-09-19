resource "aws_iam_role" "alessandro_instance_role" {
  name = "alessandro-instance-role"
  
  # Needed so that ec2 instances can assume the role
  assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AlessandroInstanceAssumeRole",
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Effect": "Allow"
            }
        ]
    })

  tags = {
      Name = "alessandro-instance-role"
  }
}

resource "aws_iam_policy" "alessandro_instance_policy" {
    name = "alessandro-instance-policy"
    description = "Policy for allowing access to s3 files to Alessandro instance."

    # Bucket is encrypted with KMS, so need both S3 and KMS permissions
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AlessandroKMSDecrypt",
                "Action": [
                    "kms:Decrypt",
                    "kms:GenerateDataKey"
                ]
                "Effect": "Allow",
                "Resource": "${aws_kms_key.alessandro_bucket_key.arn}"
            },
            {
                "Sid": "AlessandroBucketDownload",
                "Action": "s3:GetObject",
                "Effect": "Allow",
                "Resource": "${aws_s3_bucket.alessandro_bucket.arn}/*"
            }
        ]
    })
}

resource "aws_iam_instance_profile" "alessandro_instance_profile" {
  name = "alessandro_instance_profile"
  role = "${aws_iam_role.alessandro_instance_role.name}"
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.alessandro_instance_role.name}"
  policy_arn = "${aws_iam_policy.alessandro_instance_policy.arn}"
}