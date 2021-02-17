
data "template_file" "consul_server" {
  count    = 3
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
      "node_name": "consulserver-${count.index + 1}",
      "server": true,
      "bootstrap_expect": 3,
      "ui": true,
      "client_addr": "0.0.0.0"
    EOF
  }
}





data "template_file" "consul_Client_jenkins_server" {
  count    = 1
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
        "node_name": "server-jenkins-${count.index + 1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}

data "template_file" "jeninsInstall" {
  count    = 1
  template = file("${path.module}/templates/jeninsInstall.sh.tpl")
}

data "template_file" "jenkins_service" {
  count    = 1
  template = file("${path.module}/templates/jenkins_service.sh.tpl")
}


data "template_cloudinit_config" "jenkins_server" {
  count = 1
  part {
    content = element(data.template_file.consul_Client_jenkins_server.*.rendered, count.index)

  }
  part {
    content = element(data.template_file.jeninsInstall.*.rendered, count.index)
  }
  part {
    content = element(data.template_file.jenkins_service.*.rendered, count.index)
  }

}

###############################################################################

data "template_file" "consul_client_ssh" {
  count    = 2
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
        "node_name": "consul-agent-ssh${count.index + 1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}




data "template_file" "sshservice" {
  count    = 2
  template = file("${path.module}/templates/sshservice.sh.tpl")
}


data "template_cloudinit_config" "consul_client_ssh" {
  count = 2
  part {
    content = element(data.template_file.consul_client_ssh.*.rendered, count.index)

  }
  part {
    content = element(data.template_file.sshservice.*.rendered, count.index)
  }
}


















