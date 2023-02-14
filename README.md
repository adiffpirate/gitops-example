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

The infra consists of:
1. Kubernetes cluster with:
  - PostgreSQL database
