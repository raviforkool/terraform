

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.55.0"
    }
  }

}

provider "aws" {
  # Configuration options
  region = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile = "default"
}

