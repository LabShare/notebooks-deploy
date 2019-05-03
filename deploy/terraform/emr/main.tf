resource "aws_efs_file_system" "efs-volume" {
  creation_token = "jupyter"
  performance_mode = "generalPurpose"

  tags {
    Name = "jupyter"
  }
}
resource "aws_efs_mount_target" "mount-target" {
  file_system_id = "${aws_efs_file_system.efs-volume.id}"
  subnet_id = "${var.subnet-id}"
  security_groups = ["${var.emr-master-sg}", "${var.emr-slave-sg}"]
}

resource "aws_emr_cluster" "cluster" {
  name = "emr_cluster"
  release_label = "emr-5.19.0"
  applications = ["JupyterHub"]

  termination_protection = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    key_name = "${var.key-name}"
    subnet_id = "${var.subnet-id}"
    emr_managed_master_security_group = "${var.emr-master-sg}"
    emr_managed_slave_security_group  = "${var.emr-slave-sg}"
    instance_profile = "${var.ec2-role}"
  }

  master_instance_type = "m1.large"
  core_instance_type   = "m1.large"
  core_instance_count  = 2

  service_role = "${var.emr-service-role}"

  bootstrap_action {
    name = "mount_efs"
    path = "s3://${var.bootstrap-conf}"
    args = ["${aws_efs_file_system.efs-volume.dns_name}"]
  }

  depends_on = ["aws_efs_mount_target.mount-target"]

  tags {
    Name = "jupyter"
  }
}