variable "customer_gateways" {
  description = "Map of Customer Gateways for VPN connections"
  type = map(object({
    ip_address  = string
    name        = string
    asn         = string
  }))
  default = {}
}

variable "vpn_gateways" {
  description = "Map of VPN Gateways to create"
  type = map(object({
    attachment_name    = string
    network_type       = string
    local_subnets      = list(string)
    remote_subnets     = list(string)
    enable_tunnels_bgp = optional(bool, false)
    tunnel_options_specification = list(object({
      customer_gateway_key = string
      enable_nat_traversal = optional(bool, true)
      enable_dpd           = optional(bool, true)
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
        local_asn           = optional(string, null)
        tunnel_cidr         = optional(string, null)
        local_bgp_ip        = optional(string, null)
        tunnel_cidr_slave   = optional(string, null)  # BGP CIDR for slave tunnel
        local_bgp_ip_slave  = optional(string, null)  # BGP IP for slave tunnel
      })), [])
      tunnel_ipsec_config = optional(list(object({
        ipsec_pfs      = optional(string, null)
        ipsec_enc_alg  = optional(string, null)
        ipsec_auth_alg = optional(string, null)
        ipsec_lifetime = optional(number, null)
      })), [])
    }))
  }))
  default = {}
}