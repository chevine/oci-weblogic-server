resource "oci_core_network_security_group_security_rule" "fss_ingress_security_rule_1" {
  network_security_group_id = element(module.network-compute-managed-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "17"

  source      = var.wls_vcn_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  #  depends_on = [network-vcn_config.admin_nsg_id]
}

resource "oci_core_network_security_group_security_rule" "fss_ingress_security_rule_2" {
  network_security_group_id = element(module.network-mount-target-nsg[0].nsg_id, 0)
  direction                 = "INGRESS"
  protocol                  = "17"

  source      = var.wls_vcn_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  udp_options {
    source_port_range {
      min = 111
      max = 111
    }   

    destination_port_range {
      min = 111
      max = 111
    }
  }
}
