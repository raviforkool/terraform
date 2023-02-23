variable "ami" {
  
}

variable "instance_type" {}

variable "public_subnet_id" {
    ## Get from VPC module output once created
  
}


variable "key_name" {
  
}

variable "ec2_security_groups_id" {
  ## Get from VPC module output once created
}
variable "availability_zones" {}
