terraform {
 backend "gcs" {
   bucket  = "ls-compute"
   path    = "/terraform.tfstate"
   project = "ls-compute"
 }
}
