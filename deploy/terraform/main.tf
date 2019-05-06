# Configure AWS Cloud Provider
provider "aws" {
  region = "${var.AWS_REGION}"
}

module "security" {
  source = "security"

  public-key = "${var.PATH_TO_PUBLIC_KEY}"
}

module "emr" {
  source = "emr"

  key-name = "${module.security.key-name}"
  subnet-id = "${module.security.main-public-1}"
  emr-master-sg = "${module.security.emr-master-sg}"
  emr-slave-sg = "${module.security.emr-slave-sg}"
  ec2-role = "${module.security.ec2-role}"
  emr-service-role = "${module.security.emr-service-role}"
  bootstrap-conf = "${var.BOOTSTRAP_CONF}"
}