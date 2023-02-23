module "vpc_setup" {
  source = "./modules/aws_demo/vpc"
  vpc_cidr = "10.0.0.0/16" ## VPC CIDR Block
  subnet_cidrs_pub = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] ## Public subnet CIDR blocks
  subnet_cidrs_priv = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] ## Private subnet CIDR blocks
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"] ## AZs - Make sure number of AZs match with number of subnets (Public/Private)
  allow_ips = ["0.0.0.0/0"] ## List of source IP for ingress in to EC2
}

module "rds_setup" {
  source = "./modules/aws_demo/rds"
  db_name = "post_db" ## DB name
  db_username = "username" ## Username
  db_password = "password" ## Password. ## It can be derived from password vaults for better security.
  db_instance_class = "db.t3.large" ## Instance class
  db_engine_version = "13.7" ## DB version
  rds_security_group_id = module.vpc_setup.rds_security_group_id
  private_subnet_ids = module.vpc_setup.demo_private_subnet_id
  
}

module "ec2_setup" {
 source = "./modules/aws_demo/ec2"
 ami      = "ami-00eeedc4036573771" ## Ubuntu machine
 instance_type = "t2.micro" ## Instance type
 key_name = "aws-demo" ## Key pair name
 availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"] ## List of AZs as per the VPC setup
 public_subnet_id = module.vpc_setup.demo_public_subnet_id
 ec2_security_groups_id = module.vpc_setup.ec2_security_groups_id  
}