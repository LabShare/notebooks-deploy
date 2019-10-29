[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)


# Notebooks Deploy

## Setup

1. Clone the notebooks-deploy repository from GitHub using `git clone https://github.com/LabShare/notebooks-deploy`.
1. Install package dependencies using `npm i`.

## Development
### Running JupyterHub Locally
1. Create an .env file in your working directory. See the [sample-env](./sample-env) for an example. Docker-compose uses these environment variables to populate image and container arguments and environment variables. 
1. Build docker images using `npm run build`.
1. Start JupyterHub on `localhost:8000` using `npm start`.
1. JupyterHub is setup with DummyAuthenticator by default. Use any username or password to login.
1. To stop the running deployment use `npm run stop`.

## Deployment

### AWS
1. Change working directory to `deploy/jupyter-emr`.
1. Create a `sample.tfvars` to override variable defaults.
1. Run `terraform init -var-file=sample.tfvars` to load required Terraform modules.
1. Run `terraform apply -var-file=sample.tfvars` to create infrastructure and start application.
1. Access the JupyterHub interface using the `jupyterhub-dns` output.
    * JupyterHub uses PAM authentication. To add users, `ssh` into the EMR cluster master node (hadoop@<jupyterhub-dns>). 
    * Add users to the running JupyterHub docker container using `sudo docker exec jupyterhub useradd -m -s /bin/bash -N <username>`.
    * Change user passwords using `sudo docker exec jupyterhub bash -c "echo <user>:<pw> | chpasswd"`.
1. Destroy deployed application using `terraform destroy -var-file=sample.tfvars`.

### Kubernetes
1. Configure Kubernetes cluster and `kubectl`.
1. Run `kubectl apply -f run/jupyterhub-sample.yaml` to deploy application.
1. Use `kubectl get pods` and `kubectl get svc` to check application is finished deploying.
1. Access JupyterHub interface via External IP of `jupyterhub` service (`kubectl describe svc jupyterhub`).
1. If using minikube, use `minikube service jupyterhub` to get the External IP.
1. Delete deployed application using `kubectl delete -f run/jupyterhub-sample.yaml`.
