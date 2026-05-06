resource "aws_iam_role" "eks_node_group" {
    name = "eks-node-role"
    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
  
}

resource "aws_iam_role_policy_attachment" "node_role_attachment_1" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node_role.name
  
}


resource "aws_iam_role_policy_attachment" "node_role_attachment_2" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node_role.name
  
}

resource "aws_iam_role_policy_attachment" "node_role_attachment_3" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node_role.name
  
}