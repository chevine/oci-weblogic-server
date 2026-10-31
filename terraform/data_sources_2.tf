data "oci_core_network_security_groups" "vcn_nsgs" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
}
