output "consul-server_public_address" {
  value = aws_instance.server.*.public_ip
}

output "jenkins_server_public_addresses" {
  value = aws_instance.jenkins_server.*.public_ip
}

output "jenkins_slaves_public" {
  value = aws_instance.jenkins_slaves.*.public_ip
}

output "consul-server_private_address" {
  value = aws_instance.server.*.private_ip
}

output "jenkins_server_private" {
  value = aws_instance.jenkins_server.*.private_ip
}
output "jenkins_slaves_private" {
  value = aws_instance.jenkins_slaves.*.private_ip
}