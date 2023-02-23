provider "aws" {
  profile = "default"
  region = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}

## Bucket can be created by appending random string or id, but for now created it manually.

## Create Dynamodb before creating backend.
## dynamodb_table = "terraform-state-lock-dynamo"

## Once s3 bucket and dynamo db are created, update in s3_backend.tf file.

#data "terraform_remote_state" "state" {
#  backend = "s3"
#  config = {
#    bucket = aws_s3_bucket.s3_statefile.bucket
#   }
#}


resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}