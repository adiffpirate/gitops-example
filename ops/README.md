# Operations (Infrastructure)

The infrastructure is on AWS and written as code using Terraform.

## Create Infrastructure

Enter environment directory:
```
cd environments/${ENV}
```

Configure AWS access:
```
aws configure --profile gitops-example-${ENV}
```
> All AWS terraform providers are configured to use the profile `gitops-example-${ENV}`

Create [VPC](https://aws.amazon.com/vpc):
```
DIR='01_vpc'; terraform -chdir="$DIR" init && terraform -chdir="$DIR" apply
```

Create [Aurora RDS Cluster](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.html):
```
DIR='02_rds'; terraform -chdir="$DIR" init && terraform -chdir="$DIR" apply
```

Create [EKS](https://aws.amazon.com/eks):
```
DIR='03_eks'; terraform -chdir="$DIR" init && terraform -chdir="$DIR" apply
```

Before running the step below, connect to the EKS cluster:
```
aws eks update-kubeconfig --name gitops-example-${ENV} --profile gitops-example-${ENV}
```

Create [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) server and `Applications`:
```
DIR='04_argocd'; terraform -chdir="$DIR" init && terraform -chdir="$DIR" apply
```

## Deploy Application

ArgoCD will take care of deploying everything :)

To create a new app:
1. Create Helm Chart at `dev/${APP_NAME}/chart`
2. Create values file at `ops/environments/${ENV}/05_applications/${APP_NAME}_values.yaml`
3. Add `${APP_NAME}` to the list of `applications` at `ops/environments/${ENV}/04_argocd/main.tf`
4. Apply changes to ArgoCD (terraform apply)
5. Commit code. Once it hits the `master` branch ArgoCD will do his magic.

### Access

ArgoCD deploys a [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
which creates a Load Balancer to expose the applications.

To access them an DNS entry should be created for the hosts indicated on each
application Helm values. Alternatively, you can force the DNS resolution via `/etc/hosts`.

`webapp` will be exposed on path `/` and `api` will be exposed on path `/api`.

#### Example

For the `dev` environment:
```
sudo sh -c "echo \"$(host $(kubectl get svc -n ingress-nginx | grep LoadBalancer | awk '{print $4}') | head -n1 | awk '{print $4}') gitops-example-dev.foo.bar\" >> /etc/hosts"
```
- WEB APP: http://gitops-example-dev.foo.bar/
- API: http://gitops-example-dev.foo.bar/api

### Stress Test

An simple way to stress the application and check if autoscaler kicks-in

```
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stress
spec:
  replicas: 10
  selector:
    matchLabels:
      app: stress
  template:
    metadata:
      labels:
        app: stress
    spec:
      containers:
      - image: alpine/curl
        name: stress-api
        command: ["sh", "-c"]
        args: ["while true; do curl -s api; done"]
        resources:
          limits:
            cpu: 50m
            memory: 64Mi
          requests:
            cpu: 50m
            memory: 64Mi
      - image: alpine/curl
        name: stress-webapp
        command: ["sh", "-c"]
        args: ["while true; do curl -s webapp; done"]
        resources:
          limits:
            cpu: 50m
            memory: 64Mi
          requests:
            cpu: 50m
            memory: 64Mi
EOF
```
