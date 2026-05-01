variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

# List of subnet IDs for the VPC where the cluster will be created
variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster VPC."
  type        = list(string)
  default = [
    "subnet-04d3040675d19eb5c",
    "subnet-0558e34ee21f1c2f8",
    "subnet-05c8feea6185ddaad",
    "subnet-0b6b54dea4cc7b794",
    "subnet-0d1847bf244ba7d46"
  ]
}

# Node group instance type
variable "instance_type" {
  description = "EC2 instance type for EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

# Disk size (GiB) for worker nodes
variable "disk_size" {
  description = "Root disk size (GiB) for each worker node."
  type        = number
  default     = 30
}

# Scaling configuration for the node group
variable "desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 3
}
variable "min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}
variable "max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 5
}