# Deploying Jenkins Server on AWS Using Terraform from GitHub Repository

## Overview

This guide explains how to provision a Jenkins EC2 server on AWS using Terraform from your local machine. Once the Jenkins server is created, an IAM Role attached to the EC2 instance will provide AWS permissions, eliminating the need to store AWS Access Keys on the Jenkins server.

---

# Prerequisites

Before starting, ensure you have:

* AWS Account
* Git Installed
* Terraform Installed
* AWS CLI Installed
* GitHub Repository containing Terraform code
* IAM User with Programmatic Access (for initial provisioning only)

---

# Step 1: Create IAM User for Initial Provisioning

Navigate to:

AWS Console → IAM → Users → Create User

### User Name

```text
terraform-admin
```

### Permissions

Attach:

```text
AdministratorAccess
```

> This user will only be used from your local machine to provision infrastructure.

---

# Step 2: Generate Programmatic Access Credentials

Open:

```text
IAM → Users → terraform-admin → Security Credentials
```

Create Access Key.

Save:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

---

# Step 3: Install AWS CLI

### Linux

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip

unzip awscliv2.zip

sudo ./aws/install
```

Verify:

```bash
aws --version
```

Expected:

```bash
aws-cli/2.x.x
```

---

# Step 4: Configure AWS CLI

```bash
aws configure
```

Provide:

```text
AWS Access Key ID
AWS Secret Access Key
Region (Example: us-east-1)
Output Format (json)
```

Verify:

```bash
aws sts get-caller-identity
```

---

# Step 5: Install Terraform

### Ubuntu

```bash
sudo apt update

sudo apt install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt install terraform
```

Verify:

```bash
terraform version
```

---

# Step 6: Clone GitHub Repository

```bash
git clone https://github.com/<organization>/<repository>.git

cd repository
```

Example:

```bash
git clone https://github.com/company/devsecops-project.git

cd devsecops-project
```

---

# Step 7: Review Terraform Variables

Open:

```text
terraform.tfvars
```

Example:

```hcl
region = "us-east-1"

instance_type = "t3.large"

key_name = "devsecops-key"

environment = "dev"
```

Modify values as required.

---

# Step 8: Initialize Terraform

```bash
terraform init
```

Terraform downloads required providers.

Expected:

```text
Terraform has been successfully initialized
```

---

# Step 9: Validate Terraform Code

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

# Step 10: Review Infrastructure Plan

```bash
terraform plan
```

Review resources:

* EC2 Instance
* Security Groups
* IAM Instance Profile
* IAM Role
* EBS Volumes
* Elastic IP (if configured)

---

# Step 11: Create Jenkins Server

```bash
terraform apply -auto-approve
```

Terraform provisions:

* Jenkins EC2 Server
* Security Group
* IAM Role
* Instance Profile
* EBS Storage

---

# Step 12: Obtain Jenkins Server Public IP

```bash
terraform output
```

Example:

```text
jenkins_public_ip = 54.xx.xx.xx
```

---

# Step 13: Connect to Jenkins Server

```bash
ssh -i devsecops-key.pem ubuntu@<public-ip>
```

Example:

```bash
ssh -i devsecops-key.pem ubuntu@54.xx.xx.xx
```

---

# Step 14: Verify IAM Role Attachment

No AWS access keys are required on Jenkins.

Verify attached role:

```bash
aws sts get-caller-identity
```

Expected:

```text
arn:aws:sts::<account-id>:assumed-role/JenkinsAdminRole/i-xxxxxxxx
```

This confirms Jenkins is using the EC2 IAM Role.

---

# Step 15: Verify Terraform Deployment

Check:

```bash
systemctl status jenkins
```

or

```bash
docker ps
```

depending on your Terraform configuration.

---

# Architecture Flow

Local Machine
↓
AWS CLI Authentication
↓
Terraform Apply
↓
Jenkins EC2 Instance Created
↓
IAM Role Attached to EC2
↓
Jenkins Uses IAM Role
↓
Provision EKS Cluster
↓
Deploy Jenkins StatefulSet
↓
Deploy SonarQube
↓
Deploy Nexus
↓
Deploy Vault
↓
Deploy Node.js Multi-Tier Application

---

# Security Best Practices

* Use AWS Access Keys only from local machine.
* Never store AWS keys inside Jenkins.
* Attach IAM Role to Jenkins EC2.
* Use HashiCorp Vault for secrets.
* Enable SonarQube code scanning.
* Enable Trivy image scanning.
* Store artifacts in Nexus Repository.
* Use RBAC for Kubernetes access.
* Use IRSA for Kubernetes workloads.

