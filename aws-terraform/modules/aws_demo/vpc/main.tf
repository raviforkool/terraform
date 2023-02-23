resource "aws_vpc" "aws_demo_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "aws_demo"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.aws_demo_vpc.id
  count = "${length(var.subnet_cidrs_pub)}"
  availability_zone = "${var.availability_zones[count.index]}"
  cidr_block = "${var.subnet_cidrs_pub[count.index]}"
}


resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.aws_demo_vpc.id
  count = "${length(var.subnet_cidrs_priv)}"
  cidr_block = "${var.subnet_cidrs_priv[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"
}


resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.aws_demo_vpc.id
  tags = {
    "Name" = "Internet Gateway"
  }
}

resource "aws_eip" "eip" {
  #instance = aws_instance.wordpressec2.id

}
resource "aws_nat_gateway" "demo-pub-nat" {
  subnet_id = "${aws_subnet.public_subnet[0].id}"
  allocation_id = aws_eip.eip.id

  tags = {
    "Name" = "Public NAT Gateway"
  }

  depends_on = [
    aws_internet_gateway.demo-igw
  ]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.aws_demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.aws_demo_vpc.id
  route {
    nat_gateway_id = aws_nat_gateway.demo-pub-nat.id
    cidr_block = "0.0.0.0/0"

  }
}

## Public facing routing binding with public subnets
resource "aws_route_table_association" "public_rt_map" {
  #subnet_id = aws_subnet.public_subnet.id
  count = length(var.availability_zones)
  subnet_id = "${aws_subnet.public_subnet[count.index].id}"
  #subnet_id = [for sub in aws_subnet.public_subnet : sub.id]
  route_table_id = aws_route_table.public_rt.id
}

## Private subnets mapping with routing table
resource "aws_route_table_association" "private_rt_map" {
  #subnet_id = [for sub in aws_subnet.private_subnet : sub.id]
  count = length(var.availability_zones)
  subnet_id = "${aws_subnet.private_subnet[count.index].id}"
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "ec2_security_group" {
  name = "EC2 Allow"
  description = "EC2 allow SSH on port 22 from specific set of IPs"
  vpc_id = aws_vpc.aws_demo_vpc.id
  ingress {
    description = "Allow SSH on port 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]

  }
}

resource "aws_security_group" "rds_security_group" {
    name = "RDS security group"
    vpc_id = aws_vpc.aws_demo_vpc.id
    ingress {

        description = "Allow access from EC2 on 5432 port via security group"
        to_port = 5432
        from_port = 5432
        protocol = "tcp"
        security_groups = [ "${aws_security_group.ec2_security_group.id}" ]
    }
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]

  }
}