output "demo_vpc_id" {
  value = aws_vpc.aws_demo_vpc.id
}

output "demo_public_subnet_id" {
 value = aws_subnet.public_subnet.*.id
 #value = [for sub in aws_subnet.public_subnet : sub.id[*]]
 #value = ["${aws_subnet.public_subnet[0].id}", "${aws_subnet.public_subnet[1].id}", "${aws_subnet.public_subnet[2].id}"]
}

output "demo_private_subnet_id" {
  value = aws_subnet.private_subnet.*.id
  #value = ["${aws_subnet.private_subnet[0].id}", "${aws_subnet.private_subnet[1].id}", "${aws_subnet.private_subnet[2].id}"]
}

output "demo_internet_gateway_id" {
  value = aws_internet_gateway.demo-igw.id
}

output "demo_nat_gateway_id" {
  value = aws_nat_gateway.demo-pub-nat.id
}

output "ec2_security_groups_id" {
  value = aws_security_group.ec2_security_group.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_security_group.id
}