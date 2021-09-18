# Uncomment this code if you want the Terraform state to be managed remotely.
# terraform {
#     backend "s3" {
#         bucket = "nginx.alessandro.stagni.terraform"
#         key = "state"
#         encrypt = true
#         # dynamodb_table = ""
#     }
# }