resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.eks_admin_role.arn}
  username: eks-admin
  groups:
    - system:masters
- rolearn: ${aws_iam_role.ebs_csi_role.arn}
  username: ebs-csi
  groups:
    - system:serviceaccounts:kube-system
- rolearn: arn:aws:iam::165772574557:role/jenkins-ec2-admin
  username: jenkins-admin
  groups:
    - system:masters
EOF
  }

  depends_on = [
    aws_eks_cluster.my_eks_cluster,
    aws_iam_role.eks_admin_role,
    aws_iam_role.ebs_csi_role,
    aws_iam_openid_connect_provider.eks_oidc_provider,
  ]
}
