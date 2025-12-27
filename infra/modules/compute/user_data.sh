#!/bin/bash
set -e

# Update
apt-get update -y

# Install dependencies
apt-get install -y ca-certificates curl gnupg lsb-release unzip

# -----------------------
# Install Docker (resmi)
# -----------------------
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "$${UBUNTU_CODENAME:-$$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
systemctl start docker

# -----------------------
# Install AWS CLI
# -----------------------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws/


# -----------------------
# Login to ECR
# -----------------------
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
REGION=ap-southeast-1
REPO=banking-app-repo

aws ecr get-login-password --region $REGION \
  | docker login \
    --username AWS \
    --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# -----------------------
# Pull latest image
# -----------------------
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest

# -----------------------
# Run container
# -----------------------
docker run -d --restart always \
  -p 80:8000 \
  --name banking-app \
  -e DB_HOST=${db_host} \
  -e DB_USER=${db_user} \
  -e DB_PASSWORD=${db_password} \
  -e DB_NAME=${db_name} \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
