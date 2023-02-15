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

## Deploy Application

Before running the steps below, connect to the EKS cluster:
```
aws eks update-kubeconfig --name gitops-example-${ENV} --profile gitops-example-${ENV}
```

> All commands below assumes that you're inside the environment directory.

### API

```
helm upgrade --install api $(git rev-parse --show-toplevel)/dev/api/chart \
  --namespace app --create-namespace \
  --set "env.DB_HOST=$(terraform -chdir='02_rds' output -json | jq -r '.endpoint.value')" \
  --set "env.DB_PORT=$(terraform -chdir='02_rds' output -json | jq -r '.port.value')" \
  --set "env.DB_DATABASE=api" \
  --set "env.DB_USER=$(terraform -chdir='02_rds' output -json | jq -r '.created_databases.value.api.user')" \
  --set "env.DB_PASSWORD=$(terraform -chdir='02_rds' output -json | jq -r '.created_databases.value.api.password')"
```

> To access: kubectl -n app port-forward svc/api 8081:80

### WEB APP

```
helm upgrade --install webapp $(git rev-parse --show-toplevel)/dev/web_app/chart \
  --namespace app --create-namespace
```

> To access: kubectl -n app port-forward svc/webapp 8080:80

### Stress test

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
