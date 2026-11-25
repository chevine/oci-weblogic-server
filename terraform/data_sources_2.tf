data "oci_core_network_security_groups" "vcn_nsgs" {
  compartment_id = var.compartment_ocid
  vcn_id         = local.vcn_id
}

data "oci_core_subnet" "data_bastion_subnet" {
  subnet_id = module.network-bastion-subnet[0].subnet_id
}

data "oci_core_subnet" "data_lb_subnet" {
  subnet_id = module.network-lb-subnet-1[0].subnet_id
}

data "oci_core_subnet" "data_wls_subnet" {
  subnet_id = module.network-wls-private-subnet[0].subnet_id
}
/*
*/