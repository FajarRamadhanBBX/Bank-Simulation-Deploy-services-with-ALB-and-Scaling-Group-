resource "aws_ecr_repository" "app" {
  name = "banking-app-repo"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}