resource "oci_core_network_security_group_security_rule" "wls_admin_nonprod_ingress_security_rule_1" {
  network_security_group_id = element(module.network-compute-admin-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = var.bastion_subnet_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 7001
      max = 7001
    }
  }
  #  depends_on = [network-vcn_config.admin_nsg_id]
}

resource "oci_core_network_security_group_security_rule" "wls_admin_nonprod_ingress_security_rule_2" {
  network_security_group_id = element(module.network-compute-admin-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = var.wls_subnet_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 7003
      max = 7004
    }
  }
  #  depends_on = [module.network-compute-admin-nsg[0].nsg_id]
}


resource "oci_core_network_security_group_security_rule" "wls_admin_nonprod_ingress_security_rule_3" {
  network_security_group_id = element(module.network-compute-admin-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = var.bastion_subnet_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 9002
      max = 9002
    }
  }
  #  depends_on = [module.network-compute-admin-nsg[0].nsg_id]
}
