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

variable "s3_bucket_name" {
  
}
variable "dynamodb_name" {
  
}
resource "random_string" "s3_bkt" {
  length = 10
  special = false
}

resource "aws_s3_bucket" "s3_statefile" {
  bucket = lower("${var.s3_bucket_name}-${random_string.s3_bkt.id}")
}


resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = var.dynamodb_name
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_statefile.bucket
}

output "dynamodb_name" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.name
}
