resource "oci_core_network_security_group_security_rule" "lb_ingress_security_rule_1" {
  network_security_group_id = element(module.network-lb-nsg[0].nsg_id,0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = var.wls_subnet_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    source_port_range {
      min = 111
      max = 111
    }
    
    destination_port_range {
      min = 111
      max = 111
    }
  }
  #  depends_on = [network-vcn_config.admin_nsg_id]
}

resource "oci_core_network_security_group_security_rule" "lb_ingress_security_rule_2" {
  network_security_group_id = element(module.network-lb-nsg[0].nsg_id,0)
  direction                 = "INGRESS"
  protocol                  = "6"

  source      = var.wls_subnet_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    source_port_range {
      min = 2048
      max = 2050
    }
    
    destination_port_range {
      min = 2048
      max = 2050
    }
  }
  #  depends_on = [network-vcn_config.admin_nsg_id]
}

resource "oci_core_network_security_group_security_rule" "lb_ingress_security_rule_3" {
  network_security_group_id = element(module.network-lb-nsg[0].nsg_id,0)
  direction                 = "INGRESS"
  protocol                  = "17"

  source      = var.wls_subnet_cidr
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
  #  depends_on = [network-vcn_config.admin_nsg_id]
}

resource "oci_core_network_security_group_security_rule" "lb_ingress_security_rule_4" {
  network_security_group_id = element(module.network-lb-nsg[0].nsg_id,0)
  direction                 = "INGRESS"
  protocol                  = "17"

  source      = var.wls_subnet_cidr
  source_type = "CIDR_BLOCK"
  stateless   = false

  udp_options {
    source_port_range {
      min = 2048
      max = 2048
    }   

    destination_port_range {
      min = 2048
      max = 2048
    }
  }
  #  depends_on = [network-vcn_config.admin_nsg_id]
}