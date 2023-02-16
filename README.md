# GitOps Example

How DevOps and SRE principles can be used in practice to achieve Continuous Deployment
(from development to production as fast and frictionless as possible).

This repository is divided in two parts:
- [Development](dev)
- [Operations](ops)

> In reality these would be multiple repositories,
> but we're keeping everything here for the sake of simplicity.

```
├── dev
│   │
│   ├── api
│   │   ├── chart
│   │   └── src
│   │
│   └── webapp
│       ├── chart
│       └── src
│
└── ops
    │
    ├── environments
    │   └── dev
    │       ├── 01_vpc
    │       ├── 02_rds
    │       ├── 03_eks
    │       ├── 04_argocd
    │       └── 05_applications
    │
    └── tf_modules
        ├── argocd
        ├── eks
        ├── rds
        └── vpc
```

## Development

Where the application code is written.

The app consists of two microsservices:
1. WEB Application
2. API

The API is backed by a PostgreSQL database and is the only service with access to it.
Because of that, the WEB APP needs to call the API in order to get the data.

Here is also where the Helm Charts are developed so the application can be deployed on Kubernetes.

## Operations

Contains instructions on how to create the infrastructure needed.

The infrastructure is on AWS, written in Terraform, and consists of:
1. A [VPC](https://aws.amazon.com/vpc) with three subnets: public, private and database;
2. An [Aurora RDS Cluster](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.html);
3. An [EKS Cluster](https://aws.amazon.com/eks) with autoscaling;
4. An [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) Server that deploys:
    - The application (WEB APP and API);
    - [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/);
    - [Prometheus](https://prometheus.io/);
    - [Grafana](https://grafana.com/).

## CI/CD

To achieve Continuous Integration the following GitHub Actions are used:
- Dev
  - [Flake8](https://flake8.pycqa.org/en/latest/) for checking the Python code quality;
  - [Docker](https://www.docker.com/) for building the containerized images.
- Ops
  - [TFLint](https://github.com/terraform-linters/tflint) for checking the Terraform code quality;
  - [Checkov](https://www.checkov.io/) for SAST, i.e. scanning the Terraform code for security issues.

Once the changes hit the `master` branch a GitHub Action will automatically:
1. Build and push container images to DockerHub (using commit hash as tag);
2. Update values at `environments/$ENV/05_applications` with the new image tag;
3. Push changes from previous step into the `master` branch.

ArgoCD will detect the changes and sync the cluster, giving us Continuous Deployment
(without any need of human interaction).
