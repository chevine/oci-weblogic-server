resource "oci_database_autonomous_database_wallet" "wallet" {
  autonomous_database_id = var.atp_db_id
  password               = var.wallet_password

  base64_encode_content = true
  generate_type         = "SINGLE"
}

resource "local_file" "wallet_zip" {
  filename       = "${path.cwd}/wallet.zip"
  content_base64 = oci_database_autonomous_database_wallet.wallet.content
}

resource "null_resource" "extract_wallet" {

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]

    environment = {
      WALLET_PASSWORD = var.wallet_password
    }

    command = <<-EOT
      & "C:\Program Files\7-Zip\7z.exe" x `
        "${path.cwd}\wallet.zip" `
        "-p$env:WALLET_PASSWORD" `
        "-o${path.cwd}\wallet" `
        -y
    EOT
  }
}