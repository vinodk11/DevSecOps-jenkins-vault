#!/usr/bin/env bash
set -euo pipefail

# Ensure Terraform is installed
if ! command -v terraform &> /dev/null; then
  echo "Terraform not found. Please install Terraform 1.5+ before running this script."
  exit 1
fi

# Change to the project directory
cd "$(dirname "$(readlink -f "$0")")"

# Initialize Terraform, migrating any existing local state to S3
terraform init -upgrade

# Optionally, run a plan to verify everything is set up
terraform plan -out=tfplan

# Apply the plan if you wish
# terraform apply "tfplan"

echo "Remote state initialized and ready."
