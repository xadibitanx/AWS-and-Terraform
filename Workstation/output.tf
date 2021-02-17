output "WorkStation_server_public" {
  value = aws_instance.WorkStation_server.*.public_ip
}