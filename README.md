# GitOps Example

How DevOps and SRE principles can be used in practice to achieve Continuous Deployment
(from development to production as fast and frictionless as possible).

This repository is divided in two parts:
- [Development](dev)
- [Operations](ops)

> In reality these would be multiple repositories,
> but we're keeping everything here for the sake of simplicity.

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
4. An [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) Server to manage deployment.

## CI/CD

To achieve Continuous Integration the following GitHub Actions are used:
- Ops
  - [TFLint](https://github.com/terraform-linters/tflint) for checking the Terraform code quality;
  - [Checkov](https://www.checkov.io/) for SAST, i.e. scanning the Terraform code for security issues.

Once the infrastructure is up and running ArgoCD will handle all deployments
(this way we can achieve Continuous Deployment).
