terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-1188" 
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}



  data "aws_eks_cluster" "cluster" {                                                                                                  
    name = aws_eks_cluster.my_eks_cluster.name                                                                                        
  }                                                                                                                                   
                                                                                                                                      
  data "aws_eks_cluster_auth" "cluster" {                                                                                             
    name = aws_eks_cluster.my_eks_cluster.name                                                                                        
  }                                                                                                                                   
                                                                                                                                      
  provider "kubernetes" {                                                                                                             
    host                   = data.aws_eks_cluster.cluster.endpoint                                                                    
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)                                 
    token                  = data.aws_eks_cluster_auth.cluster.token                                                                  
                                                                                                                                      
    # optional: set a short request timeout to avoid hangs                                                                            
    request_timeout        = 60                                                                                                       
  }                                                                                                                                   
