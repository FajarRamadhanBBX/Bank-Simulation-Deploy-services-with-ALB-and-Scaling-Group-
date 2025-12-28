# Simple Banking System on AWS (High Availability Architecture)

Proyek ini menyimulasikan sistem perbankan sederhana yang berjalan di atas arsitektur AWS yang **High Availability**.  
Aplikasi backend dikemas sebagai Docker container, disimpan di **Amazon ECR**, dan dijalankan pada **instance EC2 di dalam Auto Scaling Group**.

Proses pembaruan Docker container dilakukan melalui **CI/CD GitHub Actions** yang akan:

- membangun image
- push image ke ECR
- memicu Auto Scaling Instance Refresh agar instance menarik image terbaru

Traffic pengguna diarahkan melalui **Application Load Balancer (ALB)**, sementara database menggunakan **Amazon RDS PostgreSQL Multi-AZ** untuk memastikan ketersediaan dan ketahanan data.

Tujuan utama proyek ini adalah mempelajari dan mengimplementasikan praktik arsitektur cloud yang:

- scalable  
- fault-tolerant  
- adaptif  
- secure  

menggunakan **Infrastructure as Code (Terraform)** dan **CI/CD** (Github Actions).

---

## 🏗 Architecture Overview

- **Application Load Balancer (Public Subnet)**  
  Menerima trafik dari internet dan mendistribusikan request ke instance EC2.

- **EC2 Auto Scaling Group (Private Subnet)**  
  Menjalankan aplikasi dalam Docker container dan melakukan scaling sesuai kebutuhan.

- **Amazon ECR**  
  Menyimpan Docker image aplikasi.

- **Amazon RDS PostgreSQL (Multi-AZ)**  
  Menyimpan data transaksi, serta dengan multi-az membuatnya fault-tolerant.

- **NAT Gateway**  
  Memberikan akses internet outbound untuk resource di private subnet.

- **IAM Role**
  - Memberikan akses ke GitHub Actions untuk push image ke ECR dan memicu Instance Refresh (Auto Scaling).
  - Memberikan akses ke EC2 instance untuk pull image dari ECR.

- **Terraform**  
  Mendefinisikan seluruh resource AWS sebagai Infrastructure as Code.

- **GitHub Actions**  
  Mengotomatiskan build image dan deployment refresh.

---

## ✨ Features

- High Availability (Multi-AZ)
- Auto Scaling backend
- CI/CD pipeline
- Private database access
- Health-based load balancing
- Secure security group rules (least-privilege)

---

## 🔄 CI/CD Workflows

1. Developer push kode ke branch `main`
2. GitHub Actions membangun Docker image
3. Image di-push ke Amazon ECR
4. Workflow memicu Auto Scaling Instance Refresh
5. EC2 instance baru dibuat
6. Instance menarik image terbaru dari ECR
7. Container dijalankan
8. ALB mulai mengarahkan traffic ke instance baru

---

## 🔐 Security Considerations

- EC2 & RDS berada di **private subnet**
- RDS tidak dapat diakses publik
- Traffic hanya masuk melalui ALB
- Security group menggunakan prinsip **least-privilege**

Security group dibagi menjadi:

- ALB (app)
- Auto Scaling Group (asg)
- Database (db)

---

## 📡 API Endpoints

| Method | Path | Deskripsi |
|-------|------|-----------|
| GET | `/ping` | Health basic check |
| GET | `/health` | App + DB health |
| POST | `/account` | Membuat akun baru |
| POST | `/balance` | Mengecek saldo |
| POST | `/add_balance` | Menambah saldo |
| POST | `/transfer` | Melakukan transfer |
| GET | `/get_all_data` | Membaca semua data akun & transaksi |
| GET | `/get_all_accounts` | Membaca semua akun |
| GET | `/get_all_transactions` | Membaca semua transaksi |

---

## 🔮 Future Improvements

- Migrasi ke ECS + AWS Fargate
- Implementasi Canary deployments
- Blue-Green deployment strategy
- Auto-rollback mechanism
