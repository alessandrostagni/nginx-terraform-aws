export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_REGION=$3
terraform init 
terraform apply -var=aws_region=$AWS_REGION