
terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~> 5.50.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"  
}


# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "path/to/your/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locking"
#     encrypt        = true
#   }
# }