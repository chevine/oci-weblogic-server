output "wallet_password" {
  value = var.wallet_password_secret_ocid
}

output "nsg_ids" {
  value = {
    lb_nsg_id           = module.network-lb-nsg[0].nsg_id
    bastion_nsg_id      = module.network-bastion-nsg[0].nsg_id
    mount_target_nsg_id = module.network-mount-target-nsg[0].nsg_id
    admin_nsg_id        = module.network-compute-admin-nsg[0].nsg_id
    managed_nsg_id      = module.network-compute-managed-nsg[0].nsg_id
  }
}

