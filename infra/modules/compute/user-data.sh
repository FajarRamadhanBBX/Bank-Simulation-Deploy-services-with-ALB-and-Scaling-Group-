#!/bin/bash
apt update -y
apt install -y docker.io awscli
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

aws ecr get-login-password --region ap-southeast-1 \
 | docker login --username AWS --password-stdin ${ecr_url}

docker pull ${ecr_url}:latest

docker run -d -p 80:8000 \
  -e DB_HOST=${db_host} \
  -e DB_USER=${db_user} \
  -e DB_PASSWORD=${db_password} \
  -e DB_NAME=${db_name} \
  ${ecr_url}:latest
