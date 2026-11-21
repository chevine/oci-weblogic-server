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

/*
resource "oci_core_subnet" "existing_bastion_subnet" {
  depends_on = [oci_core_security_list.bastion_security_list]
  vcn_id = local.vcn_id
  compartment_id = var.network_compartment_id

  cidr_block = var.bastion_subnet_cidr

  security_list_ids = [
#    data.oci_core_vcn.wls_vcn[0].default_security_list_id,
    oci_core_security_list.bastion_security_list.id
    ]
}
*/