# gcp-blockchain

Demo on how to run blockchain nodes in GCP with GKE.

# Create GKE public cluster

To create the cloud resources, terraform will be used for multiple reasons:

Terraform allows you to define your infrastructure in configuration files that can be versioned, reused, and shared. Unlike manual cluster creation or using imperative commands, IaC helps in maintaining consistency and accountability in infrastructure deployment.

Terraform configurations are idempotent, meaning that you can apply them multiple times and get the same result. This is particularly important for maintaining the desired state of your infrastructure. If something changes unexpectedly, Terraform can be rerun to correct the discrepancy.

By defining your GKE cluster as code, you can benefit from version control systems like Git. This allows you to track changes, revert to previous versions if needed, and understand the evolution of your infrastructure over time.

Terraform modules can be used to create reusable components for your infrastructure. You can create a module for your GKE clusters and reuse it across different environments or projects with different configurations.

When your infrastructure is defined as code, it's easier for teams to collaborate on its development. Pull requests and code reviews can be used to manage changes to the infrastructure, ensuring that multiple eyes have reviewed any changes before they're applied.

Terraform has first-class support for many Google Cloud Platform (GCP) features, allowing you to easily configure networking, security, IAM policies, and other services that integrate with GKE.

Terraform maintains a state file which keeps track of the resources it manages. This allows Terraform to map real-world resources to your configuration, keep track of metadata, and improve performance for large infrastructures.

Terraform can help you manage costs by giving you the ability to codify and review the resources you are provisioning before they are created. You can also use it to tear down environments when they are no longer needed, preventing unnecessary expenses.

By leveraging Terraform for GKE deployments, you benefit from repeatable processes, greater consistency, and the ability to integrate with existing CI/CD pipelines, which can significantly enhance the overall productivity and reliability of your operations.

## Create GCS bucket for Terraform state file for both cluster

The Terraform state file will be hosted in a GCS (Google Cloud Storage) bucket, and they will be created with Terraform.

# Create GKE public cluster


# Install ArgoCD

ArgoCD will be installed by using helm on the private cluster.

The public cluster has been created witha kube config file, let's use it to install ArgoCD:

```
export KUBECONFIG="${PWD}/kubeconfig-prod"

# Verify that we are using the right config:
kubecetl get pods -A

# If it's the right context, install ArgoCD.
# If it's not the right context, change the kubernetes context with kubectx for example.
# Cluster name shoud be: cluster-1-prod

# Create Namespace for ArgoCD
kubectl create namespace argocd

# Apply the ArgoCD installation YAML
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Optionally, to expose ArgoCD server using LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

# Install Prometheus Operator

# Configure ArgoCD monitoring

# Install blockchain node

# Configure blockchain node monitoring

# Add private cluster in ArgoCD

```
kubectl config get-contexts -o name
argocd cluster add cluster-2-prod-private
```

# Improvements

## Terraform 
Use Atlantis or equivalent to deploy the Terraform code. This is mainly why we are using GCS for the Terraform state file.
The workflow will be like:
- Open new PR -> atlantis plan (to show the terraform plan)
- PR Review and approved
- atlantis apply -> Apply the terraforn code (deploy it) and the PR will be merged automatically once the apply is done.

## ArgoCD

Create an ingress and use cert-manager to generate letsencrypt certificate.
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: "nginx"
  rules:
  - host: argocd.domain.tld
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              name: https
```
