resource "oci_core_network_security_group_security_rule" "wls_managed_ingress_security_rule_1" {
  network_security_group_id = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = var.wls_subnet_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  #  depends_on = [network-vcn_config.admin_nsg_id]
}

resource "oci_core_network_security_group_security_rule" "wls_managed_ingress_security_rule_2" {
  network_security_group_id = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = element(module.network-lb-nsg[0].nsg_id, 0)

  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 7004
      max = 7004
    }
  }
}

resource "oci_core_network_security_group_security_rule" "wls_managed_ingress_security_rule_3" {
  network_security_group_id = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 9072
      max = 9072
    }
  }
}

resource "oci_core_network_security_group_security_rule" "wls_managed_ingress_security_rule_4" {
  network_security_group_id = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 9002
      max = 9002
    }
  }
}

resource "oci_core_network_security_group_security_rule" "wls_managed_ingress_security_rule_5" {
  network_security_group_id = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 9004
      max = 9004
    }
  }
}


resource "oci_core_network_security_group_security_rule" "wls_managed_ingress_security_rule_6" {
  network_security_group_id = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}