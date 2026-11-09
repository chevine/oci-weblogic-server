variable "is_atp_db" {
  type        = bool
  description = "Indicating that ATP is selected"
  default     = false
}

variable "wallet_password" {
  type        = string
  description = "The password for the wallet"
  default     = "Lucinda1122##"
  sensitive   = true
}

variable "wallet_password_secret_ocid" {
  type        = string
  description = "The OCID of the secret in OCI Vault that contains the wallet password"
  default     = ""
}

#variable "nsg_ids" {
#  type        = map(list(string))
#  description = "The OCIDs of the network security groups created for the WebLogic for OCI stack"
#  default     = {}
#}

variable "nsg_source_type" {
  description = "Source type for ingress NSG rules"
  type        = string
  default     = "CIDR_BLOCK"

  validation {
    condition = contains([
      "CIDR_BLOCK",
      "NETWORK_SECURITY_GROUP",
      "SERVICE_CIDR_BLOCK"
    ], var.nsg_source_type)

    error_message = "nsg_source_type must be CIDR_BLOCK, NETWORK_SECURITY_GROUP, or SERVICE_CIDR_BLOCK."
  }
}

variable "public_key_path" {
  type        = string
  description = "Public key for ssh access to WebLogic compute instances. Use the corresponding private key to access the WebLogic compute instances"
}

variable "wls_security_rules" {
  type = list(object({
    source = string
    min_port  = number
    max_port  = number
  }))
  default     = []
  description = "List of WebLogic security groups to be created for the WebLogic for OCI stack"
}