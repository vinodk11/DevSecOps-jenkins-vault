resource "aws_eks_node_group" "eks_node_group" {
    cluster_name = aws_eks_cluster.my_eks_cluster.name
    node_group_name = "my-eks-node-group"
    node_role_arn = aws_iam_role.node_group_role.arn
    subnet_ids = var.subnet_ids
    scaling_config {
        desired_size = var.desired_size
        max_size     = var.max_size
        min_size     = var.min_size
    }

    instance_types = [var.instance_type]
    ami_type = "AL2_x86_64"
    disk_size = var.disk_size
    remote_access {
        ec2_ssh_key = var.key_pair_name
    }
    tags = {
        Name = "my-eks-node-group"
    }
    depends_on = [
        aws_iam_role_policy_attachment.worker_node_policy,
        aws_iam_role_policy_attachment.cni_policy,
        aws_iam_role_policy_attachment.registry_policy
    ]
  
}