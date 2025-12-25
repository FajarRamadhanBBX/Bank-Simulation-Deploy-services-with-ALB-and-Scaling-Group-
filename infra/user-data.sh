#!/bin/bash
apt update -y
apt install -y docker.io awscli
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

aws ecr get-login-password --region ap-southeast-1 \
 | docker login --username AWS --password-stdin ${ECR_URL}

docker pull ${ECR_URL}:latest

docker run -d -p 80:8000 \
  -e DB_HOST=${DB_HOST} \
  -e DB_USER=${DB_USER} \
  -e DB_PASSWORD=${DB_PASSWORD} \
  -e DB_NAME=${DB_NAME} \
  ${ECR_URL}:latest
