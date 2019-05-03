output "jupyterhub-dns" {
  value = "https://${module.emr.emr-cluster-dns}:9443"
}