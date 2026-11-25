/*
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}   

resource "local_file" "ssh_private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
#  filename = "${path.module}/ssh_private_key.pem"
  filename = var.private_key_path
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
#  filename = "${path.module}/ssh_public_key.pub"
  filename = var.public_key_path
  file_permission = "0644"
}
*/