resource "aws_instance" "aws_demo_instance" {
  ami = var.ami
  instance_type = var.instance_type
  #for_each = var.public_subnet_id
  count = length(var.public_subnet_id)
  subnet_id = "${var.public_subnet_id[count.index]}"
  #subnet_id = each.value
  key_name = aws_key_pair.ec2_pub_key.key_name
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${var.ec2_security_groups_id}"]
  
  #count = length(var.availability_zones)
  availability_zone = "${var.availability_zones[count.index]}"
 
}

resource "tls_private_key" "ec2_priv_key" {
    algorithm = "RSA"
    rsa_bits = 4096
  
}

resource "aws_key_pair" "ec2_pub_key" {
  key_name = var.key_name
  public_key = tls_private_key.ec2_priv_key.public_key_openssh

    provisioner "local-exec" {
      command = "echo '${tls_private_key.ec2_priv_key.private_key_pem}' > ./private-key.pem"
    }
}