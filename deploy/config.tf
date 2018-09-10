###############################################################################
##
# DO NOT NORMALLY EDIT THESE FILES
#    see: https://www.terraform.io/docs/configuration/variables.html Variable Files
#
#  See example.tfvars
#
#  Put all options in .tfvars eg:
#    terraform plan -var-file=rajrao.tfvars

###############################################################################
## Google Cloud Options

variable "gcp_cred" {
  description = "Cred secret for GCP API"
  default     = ""
}

variable "gcp_region" {
  description = "The region to place the cluster"
  default     = "us-east1"
}

variable "gcp_project" {
  description = "Google Project to invoke under"
  default     = "ls-compute"
}

###############################################################################
## DNS Setup
variable "enable_dns" {
  default = false
}

//variable "dns_zone" {
//  description = "managed DNS zone, as named in cloud provider"
//  default     = "gcp-arcts-zone"
//}
//
//variable "dns_name" {
//  description = "FQDN including trailing . (for google) to use for service"
//  default     = "j-test.labshare.org."
//}
//
//###############################################################################
//## SSL Configuration
//variable "ssl_cert" {
//  type        = "map"
//  description = "ssl certificate keys used by proxy"
//}

###############################################################################
##
#  google container engine configs
variable "gke_options" {
  type        = "map"
  description = "global options for gke/kubernetes"

  default = {
    name               = "arcts-kube"
    initial_node_count = 3

    #zone = ""   # if not defined takes first from data "google_compute_zones" "available" {}
    preemptible  = false
    disk_size_gb = 50              # size in GB, 10 is minimum value
    machine_type = "n1-standard-1"
  }
}

resource "kubernetes_config_map" "jupyterhub-config" {
  metadata {
    name = "jupyterhub-config"
  }

  data {
    jupyterhub-config.py = <<EOM

import os,sys,stat


c.JupyterHub.spawner_class='kubespawner.KubeSpawner'
c.KubeSpawner.start_timeout=1000
# Which container to spawn
c.KubeSpawner.singleuser_image_spec='wadlie/jupyterhub-user:1'

c.KubeSpawner.cmd = 'start-singleuser.sh'
c.KubeSpawner.args = ['--SingleUserNotebookApp.session_manager_class=nb2kg.managers.SessionManager', '--SingleUserNotebookApp.kernel_manager_class=nb2kg.managers.RemoteKernelManager', '--SingleUserNotebookApp.kernel_spec_manager_class=nb2kg.managers.RemoteKernelSpecManager','--allow-root']

c.KubeSpawner.singleuser_service_account='default'
# When user_storage_pvc_ensure set to True, enable user_storage_capacity
c.KubeSpawner.pvc_name_template = 'claim-{username}{servername}'
c.KubeSpawner.user_storage_capacity = '1G'
c.KubeSpawner.user_storage_pvc_ensure=True
c.KubeSpawner.debug=True

c.KubeSpawner.volumes = [
  {
   'name': 'volume-{username}{servername}',
    'persistentVolumeClaim': {
      'claimName': 'claim-{username}{servername}'
    }
  }
 ]
c.KubeSpawner.volume_mounts = [
  {
    'mountPath': '/home/jovyan/work',
    'name': 'volume-{username}{servername}'
  }
]

## mount in the NFS server to keep notebooks and data around between sessions
#c.KubeSpawner.volumes=[
#  {
#    'name': 'nfs-volume',
#    'persistentVolumeClaim': {
#      'claimName': '${module.kube-nfs.nfs-volume}'
#    }
#  }
# ]
#c.KubeSpawner.volume_mounts=[
#  {
#    'name':'nfs-volume',
#    'mountPath':'/mnt/'
#  }
# ]

c.JupyterHub.authenticator_class='dummyauthenticator.DummyAuthenticator'

c.JupyterHub.allow_named_servers=True
c.JupyterHub.ip='0.0.0.0'
c.JupyterHub.hub_ip='0.0.0.0'
c.JupyterHub.cleanup_servers=False

# c.ConfigurableHTTPProxy.should_start=False
c.JupyterHub.cookie_secret_file = '/srv/jupyterhub/jupyterhub_cookie_secret'

EOM
      }
}
