resource "aws_db_subnet_group" "main" {
  name       = "bank-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  instance_class    = "db.t3.micro"
  allocated_storage = 10
  storage_type      = "gp2"

  engine         = "postgres"
  engine_version = "16.3"

  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]
  publicly_accessible    = false

  skip_final_snapshot = true
  multi_az            = true

  tags = {
    Name = "Bank-db-postgresql"
  }
}