module "vpc" {
    source = "./modules/vpc"
  
}

module "role_creation" {
    source = "./modules/iam"
  
}