# AWS Automation with Bash: S3 & EC2 Setup Script

This repository contains a Bash script that automates the setup of essential AWS resources using the AWS CLI.  
The script ensures the AWS CLI is installed, creates an S3 bucket with a sample object, and launches an EC2 instance.

---

## 🚀 Features
- **AWS CLI Check & Install**: Automatically installs AWS CLI v2 if not already installed.
- **S3 Bucket Creation**:
  - Creates a unique S3 bucket with a timestamp and process ID.
  - Uploads a sample text file (`sample.txt`) to the bucket.
- **EC2 Instance Creation**:
  - Launches an EC2 instance (`add this according to your requirements`) using Amazon Linux 2 AMI.
  - Tags the instance with the name `add this according to your requirements`.
  - Waits until the instance is in the `running` state before continuing.

---

## 📋 Prerequisites
- Linux-based system with `bash`.
- AWS account with programmatic access (Access Key & Secret Key).
- IAM user/role with permissions for:
  - `s3:CreateBucket`, `s3:PutObject`
  - `ec2:RunInstances`, `ec2:DescribeInstances`
- Installed dependencies:
  - `curl`
  - `unzip`
  - `awscli` (auto-installed by script if missing)

---
