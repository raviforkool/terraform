variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs_pub" {
  type = list
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
 }

 variable "subnet_cidrs_priv" {
   type = list
   default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
 }

 variable "availability_zones" {
   type = list
   default = ["us-west-1a", "us-west-1b", "us-west-1c"] 
 }

variable "allow_ips" {
  type = list
  default = ["0.0.0.0/0"]
}
