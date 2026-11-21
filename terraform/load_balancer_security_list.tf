resource "oci_core_security_list" "lb_tcp_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "${var.wls_vcn_name}-lb-tcp-security-list"

  dynamic "ingress_security_rules" {
    for_each = var.lb_tcp_security_rules

    content {
      protocol = ingress_security_rules.value.protocol
      source   = ingress_security_rules.value.source
      tcp_options {
        min = ingress_security_rules.value.min_port
        max = ingress_security_rules.value.max_port
      }
    }
  }
}

resource "oci_core_security_list" "lb_udp_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "${var.wls_vcn_name}-lb-udp-security-list"

  dynamic "ingress_security_rules" {
    for_each = var.lb_udp_security_rules

    content {
      protocol = ingress_security_rules.value.protocol
      source   = ingress_security_rules.value.source
      udp_options {
        min = ingress_security_rules.value.min_port
        max = ingress_security_rules.value.max_port
      }
    }
  }
}