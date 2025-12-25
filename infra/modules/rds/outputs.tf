output "db_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "port" {
  value = aws_db_instance.rds.port
}

output "db_name" {
  value = aws_db_instance.rds.db_name
}