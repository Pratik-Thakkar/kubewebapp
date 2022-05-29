provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.webapp-dev-eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.webapp-dev-eks.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.webapp-dev-eks.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "webapp" {
  depends_on       = [module.webapp-dev-eks]
  name             = "kubewebapp"
  chart            = "./webappchart"
  namespace        = "webapp"
  max_history      = 3
  create_namespace = true
  wait             = true
  reset_values     = true
}