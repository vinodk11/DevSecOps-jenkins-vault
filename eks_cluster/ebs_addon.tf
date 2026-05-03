resource "aws_eks_addon" "ebs_csi" {
    cluster_name = aws_eks_cluster.my_eks_cluster.name
    addon_name = "aws-ebs-csi-driver"
    resolve_conflicts_on_create = "OVERWRITE"
    service_account_role_arn = aws_iam_role.ebs_csi_role.arn

   depends_on = [                                                                                                                    
      aws_eks_cluster.my_eks_cluster,                                                                                                 
      aws_iam_role_policy_attachment.ebs_csi_policy,
      aws_iam_openid_connect_provider.eks_oidc_provider   // <‑‑ OIDC provider
    ]  
  
}