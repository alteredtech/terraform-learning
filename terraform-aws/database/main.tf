# --- database/main.tf ---

resource "aws_db_instance" "alt_db" {
  allocated_storage      = var.db_storage #gibibytes
  engine                 = "mysql"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  identifier             = var.db_identifier
  skip_final_snapshot    = var.skip_final_snapshot
  tags = {
    Name = "alt-db"
  }
}