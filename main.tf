locals {
  tags = {
    Name               = "Web_VPC"
    Environment        = "Dev"
    Application        = "Front End"
  }
}


module "vpc" {
    source = "./modules/vpc"
  
}

module "role_creation" {
    source = "./modules/iam"
  
}

module "test_eks" {
    source = "./modules/eks"
    cluster_name = "test"
    subnet_ids = [ module.vpc.web_vpc_subnet_ids ] 
    key_name = "test"
    # role = module.iam.eks_cluster_role_name
    # role_arn = module.iam.eks_cluster_role_arn
    

}