resource "aws_db_instance" "rds_demo_instance" {
  allocated_storage      = 10
  db_name                = var.db_name
  instance_class         = var.db_instance_class
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = ["${var.rds_security_group_id}"]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_gp.id
  username               = var.db_username
  password               = var.db_password
  ## Make sure DB manual password change is ignored
    lifecycle {
    ignore_changes = [password]
  }

}

resource "aws_db_subnet_group" "rds_subnet_gp" {
  subnet_ids = var.private_subnet_ids
  #subnet_ids = ["${var.private_subnet_ids[0]}","${var.private_subnet_ids[1]}","${var.private_subnet_ids[2]}"]
}

