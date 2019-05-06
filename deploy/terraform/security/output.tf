output "vpc-id" {
  value = "${aws_vpc.main.id}"
}

output "ec2-role" {
  value = "${aws_iam_instance_profile.emr_ec2_instance_profile.arn}"
}

output "emr-service-role" {
  value = "${aws_iam_role.emr_service_role.arn}"
}

output "subnets-public" {
  value = "${formatlist("%v", aws_subnet.public.*.id)}"
}

output "main-public-1" {
  value = "${aws_subnet.public.*.id[0]}"
}

output "main-public-2" {
  value = "${aws_subnet.public.*.id[1]}"
}

output "emr-master-sg" {
  value = "${aws_security_group.emr_master.id}"
}

output "emr-slave-sg" {
  value = "${aws_security_group.emr_slave.id}"
}

output "key-name" {
  value = "${aws_key_pair.mykeypair.key_name}"
}
