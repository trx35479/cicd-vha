# provision the schema of oracle rds
# boostrap the Dev and Systest Instance
# boostrapping will be done by terraform remote-exec provisioner in place of cloud-init

#resource "null_resource" "rdsCreateSchema" {
#  triggers {
#    rds_endpoint = "${module.vha-dev-rds.rds_endpoint}"
#  }
#
#  provisioner "local-exec" {
#    command = "echo exit | sqlplus64 ${var.DB_USERNAME}/${var.DB_PASSWORD}@${module.vha-dev-rds.rds_endpoint}/${var.DATABASE_NAME} @templates/create_table.sql"
#  }
#}
data "template_file" "formatKeys" {
  template = "${file(var.JENKINS_PUBLIC_KEY)}"
}

resource "null_resource" "bootstrapSystestInstance" {
  count = "${var.ENABLE_TEST == "true" ? 1 : 0}"
  triggers {
    instance_id = "${element(module.vha-systest-instance.instance_ids, 0)}"
  }

  connection {
    host        = "${element(module.vha-systest-instance.private_ips, 0)}"
    private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
    user        = "ec2-user"
    type        = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo useradd jenkins",
      "sudo echo 'jenkins ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers.d/jenkins",
      "sudo chmod 440 /etc/sudoers.d/jenkins",
      "sudo mkdir /home/jenkins/.ssh/",
      "sudo touch /home/jenkins/.ssh/authorized_keys",
      "sudo echo '${data.template_file.formatKeys.rendered}' | sudo tee -a /home/jenkins/.ssh/authorized_keys",
      "sudo chown -R jenkins:jenkins /home/jenkins/.ssh",
      "sudo chmod 700 /home/jenkins/.ssh/",
      "sudo chmod 600 /home/jenkins/.ssh/authorized_keys",
    ]
  }
}

# bootstrap Matrixx

resource "null_resource" "bootstrapMtxInstance" {
  triggers {
    instance_id = "${element(module.vha-systest-instance-mtx.instance_ids, 0)}"
  }

  connection {
    host        = "${element(module.vha-systest-instance-mtx.private_ips, 0)}"
    password    = "password"
    user        = "deploy"
    type        = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "msd start vha-5083-1subdomain",
    ]
  }

  depends_on = ["null_resource.bootstrapSystestInstance"]
}
