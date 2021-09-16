terraform {
    backend "s3" {
        bucket = "nginx.alessandro.stagni.terraform"
        key = "state"
        encrypt = true
        # dynamodb_table = ""
    }
}