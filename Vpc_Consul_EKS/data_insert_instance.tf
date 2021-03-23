
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



#######################################################################3333

data "template_file" "jenkins_server" {
  count    = 1
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
        "node_name": "jenkins_server-${count.index + 1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}



data "template_file" "jenkins_service" {
  count    = 1
  template = file("${path.module}/templates/jenkins_service.sh.tpl")
}


data "template_cloudinit_config" "jenkins_server" {
  count = 1
  part {
    content = element(data.template_file.jenkins_server.*.rendered, count.index)

  }

  part {
    content = element(data.template_file.jenkins_service.*.rendered, count.index)
  }

}

###############################################################################

data "template_file" "consul_client_jenkins_slave" {
  count    = 2
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
        "node_name": "consul_client_jenkins_slave${count.index + 1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}



data "template_file" "sshservice" {
  count    = 2
  template = file("${path.module}/templates/sshservice.sh.tpl")
}


data "template_cloudinit_config" "consul_client_jenkins_slave" {
  count = 2
  part {
    content = element(data.template_file.consul_client_jenkins_slave.*.rendered, count.index)

  }
  part {
    content = element(data.template_file.sshservice.*.rendered, count.index)
  }
}



#######################################################################333

data "template_file" "monitor" {
  count    = 1
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
        "node_name": "consul_client_monitor-${count.index + 1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}

data "template_file" "prometheus" {
  count    = 1
  template = file("${path.module}/templates/prometheus.sh.tpl")
}
data "template_cloudinit_config" "monitor" {
  count = 1
  part {
    content = element(data.template_file.monitor.*.rendered, count.index)

  }
    part {
    content = element(data.template_file.prometheus.*.rendered, count.index)
  }
}

########################################################################




data "template_file" "consul_client_Mysql" {
  count    = 1
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
        "node_name": "consul_client_monitor${count.index + 1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}

data "template_file" "mysql" {
  count    = 1
  template = file("${path.module}/templates/mysql.sh.tpl")
}
data "template_cloudinit_config" "consul_client_Mysql" {
  count = 1
  part {
    content = element(data.template_file.consul_client_Mysql.*.rendered, count.index)

  }
    part {
    content = element(data.template_file.mysql.*.rendered, count.index)
  }
}










