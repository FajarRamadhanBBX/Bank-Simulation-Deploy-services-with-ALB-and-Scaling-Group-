resource "aws_ecr_repository" "app" {
  name = "banking-app-repo"
  force_delete = true
}