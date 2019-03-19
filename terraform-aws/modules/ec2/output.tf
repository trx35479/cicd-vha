# Expose attributes instance attribute

output "private_ips" {
  value = "${aws_instance.ec2-instance.*.private_ip}"
}

output "public_ips" {
  value = "${aws_instance.ec2-instance.*.public_ip}"
}

output "private_dns" {
  value = "${aws_instance.ec2-instance.*.private_dns}"
}

output "public_dns" {
  value = "${aws_instance.ec2-instance.*.public_dns}"
}

output "instance_ids" {
  value = "${aws_instance.ec2-instance.*.id}"
}

output "instance_arns" {
  value = "${aws_instance.ec2-instance.*.arn}"
}
