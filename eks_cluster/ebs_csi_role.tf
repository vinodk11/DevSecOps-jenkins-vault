resource "aws_iam_role" "ebs_csi_role" {
    name = "ebs-csi-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
  
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.ebs_csi_role.name
  
}