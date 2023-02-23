variable "region" {}
variable "vpc_cidr_block" {}

//variable "subnet_pub_1" {}
//variable "subnet_pri_1" {}
//variable "subnet_pri_2" {}

variable "public_cidrs" {
    type = list(string)
  
}
variable "private_cidrs" {
    type = list(string)
  
}

variable "availability_zones" {
  type = list(string)
}
//variable "av_zone1" {}
//variable "av_zone2" {}
//variable "av_zone3" {}



variable "db_instance_class" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "db_multi_az" {
  type = bool
  default = true
}
variable "ami" {}
variable "ec2_type" {}
#variable "vol_size" {}

variable "wp_key_pair_pub" {}