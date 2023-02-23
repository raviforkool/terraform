output "ec2_instance_public_dns" {
  value = [for pub_dns in aws_instance.aws_demo_instance : pub_dns.public_dns]
  
}