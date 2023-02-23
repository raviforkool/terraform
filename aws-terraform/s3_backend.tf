provider "aws" {
  profile = "default"
  region = var.region
  shared_credentials_files = ["~/.aws/credentials"]
}


terraform {
  backend "s3" {
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
    key = "terraform.tfstate"
    bucket = "tf-demo-testing-7352514133901"
    region = "us-east-2"
  }
}

