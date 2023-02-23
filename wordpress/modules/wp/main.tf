provider "aws" {
  region = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile = "default"
}

## Create VPC

resource "aws_vpc" "wp_vpc" {
  cidr_block         = var.vpc_cidr_block
  enable_dns_support = "true"
  enable_dns_hostnames    = "true"
  instance_tenancy   = "default"
  tags = {
    "Name" = "Wordpress_VPC"
  }
}

## Create Public Subnet for web-server
resource "aws_subnet" "wp_vpc_public" {
  vpc_id                  = aws_vpc.wp_vpc.id
  count = length(var.availability_zones)
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.availability_zones[count.index]}"
  tags = {
    "Name" = "Public_subnet_${var.availability_zones[count.index]}"
  }
}

## Create Private subnets for RDS
resource "aws_subnet" "wp_vpc_private" {
  vpc_id                  = aws_vpc.wp_vpc.id
  count = length(var.availability_zones)
  cidr_block              = "${var.private_cidrs[count.index]}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.availability_zones[count.index]}"
  tags = {
    "Name" = "Private_subnet_${var.availability_zones[count.index]}"
  }
}


## Create Internet GateWay 

resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id
}


## Create Route Table

resource "aws_route_table" "public_facing" {
  vpc_id = aws_vpc.wp_vpc.id

  route {
    ## Associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    ## Gateway to internet
    gateway_id = aws_internet_gateway.wp_igw.id
  }


}


## Binding route table with public subnet
resource "aws_route_table_association" "rt_wp_vpc_public-1" {
  count =  length(var.availability_zones)
  subnet_id      = "${aws_subnet.wp_vpc_public[count.index].id}"
  route_table_id = aws_route_table.public_facing.id
}


## Security groups for WP server (EC2)

resource "aws_security_group" "wp_server_allow" {
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    description = "Outbound traffic"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.wp_vpc.id

}


## Security group for MySQL

resource "aws_security_group" "mysql_sg_allow" {
  ingress {

    description     = "MySQL"
    to_port         = 3306
    from_port       = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.wp_server_allow.id}"]
  }
  egress {

    description = "Outbound traffic"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    "Name" = "allow wp server"
  }

}


## Create RDS subnet group

resource "aws_db_subnet_group" "mysql_sub_grp" {
  #count =  length(var.availability_zones)
  subnet_ids = ["${aws_subnet.wp_vpc_private[0].id}","${aws_subnet.wp_vpc_private[1].id}"]

}

## Create MySQL Instance

resource "aws_db_instance" "wp_mysql_ins" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.db_instance_class
  #count = length(var.availability_zones)
  db_subnet_group_name   = aws_db_subnet_group.mysql_sub_grp.id
  vpc_security_group_ids = ["${aws_security_group.mysql_sg_allow.id}"]
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  multi_az = var.db_multi_az
  ## Make sure DB manual password change is ignored
  lifecycle {
    ignore_changes = [password]
  }


}

## user_data file for setting up wordpress after RDS endpoint is ready

data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    db_name          = var.db_name
    db_username      = var.db_username
    db_user_password = var.db_password
    db_rds           = aws_db_instance.wp_mysql_ins.endpoint

  }

}

## Create EC2/WP server (Only after MySQL is created)

resource "aws_instance" "wp_ec2_ins" {
  ami                    = var.ami
  instance_type          = var.ec2_type
  count = length(var.availability_zones)
  subnet_id              = "${aws_subnet.wp_vpc_public[count.index].id}"
  vpc_security_group_ids = ["${aws_security_group.wp_server_allow.id}"]
  user_data              = data.template_file.user_data.rendered
  key_name               = aws_key_pair.wp_key.id
  tags = {
    "Name" = "Wordpress Server-${var.availability_zones[count.index]}"
  }

  depends_on = [aws_db_instance.wp_mysql_ins]

}

## Maps public key with EC2 instance
resource "aws_key_pair" "wp_key" {
  key_name   = "wp_key"
  public_key = file(var.wp_key_pair_pub)

}


### ELB setup
resource "aws_lb_target_group" "wp_target_gp" {
  name = "wp-target-gp"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.wp_vpc.id
}


resource "aws_lb" "wp_alb" {
  name = "wordpress-alb"
  internal = "false"
  load_balancer_type = "application"
  security_groups = [aws_security_group.wp_server_allow.id]
  subnets = [for subnet in aws_subnet.wp_vpc_public : subnet.id]

}

resource "aws_lb_listener" "wp_listener" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.wp_target_gp.arn
  }
}

resource "aws_lb_listener_rule" "wp_listener_rule" {
  listener_arn = aws_lb_listener.wp_listener.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.wp_target_gp.arn
  }
  condition {
    path_pattern {
    values = ["/"]
    }
  }
}

resource "aws_lb_target_group_attachment" "wp_lb_attach" {
  target_group_arn = aws_lb_target_group.wp_target_gp.arn
  count = length(var.availability_zones)
  target_id = "${aws_instance.wp_ec2_ins[count.index].id}"
  port = 80
}
## Create Elastic IP for WP Server

output "Wordpress_LB_DNS" {
  value = aws_lb.wp_alb.dns_name
}


output "MySQL_Endpoint" {
  value = aws_db_instance.wp_mysql_ins.endpoint
}
