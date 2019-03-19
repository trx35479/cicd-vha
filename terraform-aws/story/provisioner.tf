# boostrap the Story instance
# boostrapping will be done by terraform remote-exec provisioner in place of cloud-init

data "template_file" "formatKeys" {
  template = "${file(var.JENKINS_PUBLIC_KEY)}"
}

resource "null_resource" "bootstrapStoryInstance" {
  triggers {
    instance_id = "${element(module.vha-story-instance.instance_ids, 0)}"
  }

  connection {
    host        = "${element(module.vha-story-instance.private_ips, 0)}"
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
    instance_id = "${element(module.vha-story-instance-mtx.instance_ids, 0)}"
  }

  connection {
    host        = "${element(module.vha-story-instance-mtx.private_ips, 0)}"
    password    = "password"
    user        = "deploy"
    type        = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "msd start vha-5083-1subdomain",
    ]
  }

  depends_on = ["null_resource.bootstrapStoryInstance"]
}
