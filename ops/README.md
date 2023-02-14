# Operations (Infrastructure)

## Kubernetes

First we need to create a Kubernetes cluster.
We'll be using [Kind](https://kind.sigs.k8s.io/) for now.
```
kind create cluster --image kindest/node:v1.25.3
```

Once the cluster is created, install the Metrics Server:
```
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server \
  && helm upgrade --install metrics-server metrics-server/metrics-server \
    --namespace kube-system \
    --set "args={--kubelet-insecure-tls}" 
```

## Database

Create PostgreSQL database on K8s cluster
```
helm repo add bitnami https://charts.bitnami.com/bitnami \
  && helm upgrade --install postgresql bitnami/postgresql \
    --namespace db --create-namespace \
    --set "global.postgresql.auth.username=test" \
    --set "global.postgresql.auth.password=test"
```

## Deploy Application

### API

```
helm upgrade --install api $(git rev-parse --show-toplevel)/dev/api/chart \
  --namespace app --create-namespace \
  --set "env.DB_HOST=postgresql.db"
```

> To access: kubectl -n app port-forward svc/api 8081:80

### WEB APP

```
helm upgrade --install webapp $(git rev-parse --show-toplevel)/dev/web_app/chart \
  --namespace app --create-namespace
```

> To access: kubectl -n app port-forward svc/webapp 8080:80
