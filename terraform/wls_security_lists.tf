resource "oci_core_security_list" "wls_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
  display_name   = "${var.wls_vcn_name}-wls-security-list"

  dynamic "ingress_security_rules" {
    for_each = var.wls_security_rules

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
data "oci_core_subnet" "existing_wls_subnet" {
  depends_on = [module.network-wls-private-subnet]
  subnet_id = var.wls_subnet_id
} 

resource "oci_core_subnet" "existing_wls_subnet" {
#  depends_on = [module.network-wls-private-subnet]
  depends_on = [oci_core_security_list.wls_security_list]
  vcn_id = local.vcn_id
  compartment_id = var.network_compartment_id
  cidr_block = var.wls_subnet_cidr

  security_list_ids = [oci_core_security_list.wls_security_list.id, oci_core_security_list.wls_security_list.id]

}
*/