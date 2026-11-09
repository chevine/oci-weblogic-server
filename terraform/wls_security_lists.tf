resource "oci_core_security_list" "wls_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = module.network-vcn[0].vcn_id
  display_name   = "${var.wls_vcn_name}-wls-security-list"

  dynamic "ingress_security_rules" {
    for_each = var.wls_security_rules

    content {
      protocol = "6"
      source   = ingress_security_rules.value.source

      tcp_options {
        min = ingress_security_rules.value.min_port
        max = ingress_security_rules.value.max_port
      }
    }
  }
}
