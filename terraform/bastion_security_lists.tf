resource "oci_core_security_list" "bastion_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "${var.wls_vcn_name}-bastion-security-list"

  dynamic "ingress_security_rules" {
    for_each = var.bastion_security_rules

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