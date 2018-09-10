[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)


# Compute

Goal is to build a JupyterHub instance on Kubernetes and deploy it to Google Cloud

## Setup

1. Clone the ls-compute repository from GitHub using `git clone https://github.com/LabShare/compute`.
2. Install package dependencies using `npm i`.

## Development
### Running JupyterHub Locally
1. Build docker images using `npm run build`.
2. Start JupyterHub on `localhost:8000` using `npm start`.
3. To create user accounts on JupyterHub, access the container shell using `docker exec -ti jupyterhub bash`.
4. Create a new user using `useradd <username>` and set a password using `passwd <username>`.


## Deployment
### Kubernetes

### Terraform

Most options are documented in `sample.tfvars` and `config.tf`.
Terraform will create a new GKE to use. Jupyterhub and other modules are deployed, and the IP for Jupyterhub will be exposed.

 1. Create GCP Service Account create a key pair and download the secret. See [Managing GCP Projects with Terraform] (https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform)
 1. Assign Service account IAM roles:
    1. Viewer
    1. Compute Admin
    1. DNS Administrator (If using DNS Config)
    1. Kubernetes Engine Admin
    1. Service Account User
    1. Storage Admin (For remote backend recommended)
 1. Create GCP bucket to hold Terraform state
 1. Update `backend.tf` for bucket, prefix, and project name
 1. Update `sample.tfvars` for creds,instance node options, and service account name
 1. Setup Cloud DNS Zone if not already exists in your project or disable
 1. Run: `terraform init -var-file=custom.tfvars` once
 1. Validate plan: `terraform plan -var-file=sample.tfvars`
 1. Apply plan: `terraform apply -var-file=sample.tfvars`
 1. Tear it all down: `terraform destroy -var-file=sample.tfvars`

### Docker container for Terraform

 * The `images` folder has a container definition for a jupyterhub with the needed add-ons
 * Within the `run` folder, the `kernel-gateway` folder has the container definition for kernel-gateway
 * Update to latest jupyterhub base container: `docker pull jupyterhub/jupyterhub`
 * Build eg: `docker build -t sample/juputerhub:0.1 .`
 * Push to dockerhub: `docker push sample/jupyterhub:0.1`
 * Update `juptyerhub/main.tf` to point to the new version/container
 * Repeat the same for `kernel-gateway` and update in `kernel-gateway/main.tf`
