variable "create_vpn_customer_gateway" {
  description = "Whether to create vpn customer gateway."
  type        = string
  default     = true
}

variable "cgw_id" {
  description = "The customer gateway id used to connect with vpn gateway."
  type        = string
  default     = null
}

variable "cgw_name" {
  description = "The name of the VPN customer gateway. Defaults to null."
  type        = string
  default     = ""
}

variable "cgw_ip_address" {
  description = "The IP address of the customer gateway."
  type        = string
  default     = ""
}

variable "customer_gateways" {
  description = "Map of Customer Gateways for VPN connections"
  type = map(object({
    ip_address  = string
    name        = string
  }))
  default = {}
}


variable "enable_tunnels_bgp" {
  description = "Whether to enable BGP for the tunnels."
  type        = bool
  default     = null
}


variable "network_type" {
  description = "The type of the network Public or Private"
  type        =  string
  default     = "public"
}

variable "attachment_name" {
  description = "The prefix of the VPN attachment name."
  type        = string
}

variable "tunnel_options_specification" {
  type = list(object({
    role                 = optional(string, null)
    status               = optional(string, null)
    customer_gateway_key  = optional(string, null)
    enable_nat_traversal = optional(bool, null)
    enable_dpd           = optional(bool, null)
    tunnel_ike_config = optional(list(object({
      ike_auth_alg = optional(string, null)
      local_id     = optional(string, null)
      ike_enc_alg  = optional(string, null)
      ike_version  = optional(string, null)
      ike_mode     = optional(string, null)
      ike_lifetime = optional(string, null)
      psk          = optional(string, null)
      remote_id    = optional(string, null)
      ike_pfs      = optional(string, null)
    })), [])
    tunnel_bgp_config = optional(list(object({
      local_asn    = optional(string, null)
      tunnel_cidr  = optional(string, null)
      local_bgp_ip = optional(string, null)
    })), [])
    tunnel_ipsec_config = optional(list(object({
      ipsec_pfs      = optional(string, null)
      ipsec_enc_alg  = optional(string, null)
      ipsec_auth_alg = optional(string, null)
      ipsec_lifetime = optional(number, null)
    })), [])
  }))
  description = "The tunnel options specification config."
  default     = []
}