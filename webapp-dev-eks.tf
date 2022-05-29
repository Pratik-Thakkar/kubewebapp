data "aws_eks_cluster" "webapp-dev-eks" {
  name = module.webapp-dev-eks.cluster_id
}

data "aws_eks_cluster_auth" "webapp-dev-eks" {
  name = module.webapp-dev-eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.webapp-dev-eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.webapp-dev-eks.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.webapp-dev-eks.name]
    command     = "aws"
  }
}

module "webapp-dev-eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.21.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    node1 = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}