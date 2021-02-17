
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





data "template_file" "consul_client" {
  count    = 1
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config         = <<EOF
        "node_name": "consul-agent-${count.index + 1}",
        "enable_script_checks": true,
        "server": false
      EOF
  }
}



data "template_file" "Prometheus" {
  count    = 1
  template = file("${path.module}/templates/Prometheus.sh.tpl")
}


data "template_cloudinit_config" "consul_client" {
  count = 1
  part {
    content = element(data.template_file.consul_client.*.rendered, count.index)

  }

    part {
    content = element(data.template_file.Prometheus.*.rendered, count.index)
  }

}
