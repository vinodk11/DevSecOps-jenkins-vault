
# DevSecOps-jenkins-vault
Three-Tier Web Application Deployment on AWS EKS using EKS, vault, Prometheus, Grafana, and Jenkins as statefulset






DevSecOps-jenkins-vault/
├── LICENSE
├── README.md
├── eks_cluster
│   ├── Jenkinsfile
│   ├── README.md
│   ├── alb_controller.tf
│   ├── backend. 
│   ├── ebs_csi_role.tf
│   ├── eks_cluster.tf
│   ├── eks_node_group.tf
│   ├── eks_node_grp_sg.tf
│   ├── iam_auth.tf
│   ├── iam_policy_alb.json
│   ├── oidc_provider.tf
│   ├── provider.tf
│   └── variables.tf
├── jenkins_server
│   ├── README.md
│   ├── iam_ec2_admin.tf
│   ├── install_script.sh
│   ├── w2-SG.tf
│   ├── w2-data-source.tf
│   ├── w2-ec2.tf
│   ├── w2-output.tf
│   ├── w2-provider.tf
│   └── w2-varibales.tf
└── jenkins_vault
    ├── Jenkinsfile
    ├── jenkins_stateful_set
    │   ├── ingress.yaml
    │   ├── name_space.yaml
    │   ├── service.yaml
    │   ├── service_account.yaml
    │   ├── statefulset.yaml
    │   └── storage_class.yaml
    └── vault
        ├── ingress.yaml
        ├── name_space.yaml
        ├── pvc.yaml
        ├── service.yaml
        ├── serviceaccount.yaml
        └── stateful_set.




