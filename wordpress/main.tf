module "wp_aws_cloud" {

  source = "./modules/wp"

  region         = "us-east-2" ## AWS Region
  vpc_cidr_block = "10.0.0.0/16" ## VPC CIDR Block
  public_cidrs = ["10.0.30.0/24","10.0.40.0/24" ] ## Public CIDR Block **Note: Make sure to match number of subnets with AZs
  private_cidrs = ["10.0.50.0/24","10.0.60.0/24" ] ## Private CIDR Block
  availability_zones = ["us-east-2a", "us-east-2b"] ## Availabiliy zones

  db_instance_class = "db.t2.micro" ## DB instance type
  db_username       = "username" ## DB user name
  db_password       = "password" ## DB passsword -It can be derived from password vaults for better security.
  db_name           = "wp_db" ## DB name
  db_multi_az =  true ## Mutli-AZ

  ami      = "ami-0568936c8d2b91c4e" ## Ubuntu machine
  ec2_type = "t2.micro" ## EC2 instance type
  wp_key_pair_pub = "./wp_key.pub" ## This needs to created on local machine before running terraform apply.

}


output "Wordpress_LoadBalancer_DNS" {
  value = module.wp_aws_cloud.Wordpress_LB_DNS
}
