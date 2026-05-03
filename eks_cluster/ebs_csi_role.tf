resource "aws_iam_role" "ebs_csi_role" {
  name = "ebs-csi-role"

  # Trust the EKS OIDC provider for IRSA
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_oidc_provider.arn
      }
      Action    = "sts:AssumeRoleWithWebIdentity"
      # Optional condition to restrict to the specific service account
      # Condition = {
      #   StringEquals = {
      #     "${replace(aws_iam_openid_connect_provider.eks_oidc_provider.url, \"https://\", \"\")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      #   }
      # }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.ebs_csi_role.name
  
}