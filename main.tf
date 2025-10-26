# Create Customer Gateways
resource "alicloud_vpn_customer_gateway" "this" {
  for_each = var.customer_gateways
  
  ip_address            = each.value.ip_address
  customer_gateway_name = each.value.name
}

# Create VPN Gateway Attachments
resource "alicloud_vpn_gateway_vpn_attachment" "this" {  
  network_type        = var.network_type
  local_subnet        = join(",", each.value.local_subnets)
  remote_subnet       = join(",", each.value.remote_subnets)
  enable_tunnels_bgp  = var.enable_tunnels_bgp
  vpn_attachment_name = var.attachment_name
  
  # Dynamic tunnel configuration based on tunnel_options_specification
  dynamic "tunnel_options_specification" {
    for_each = var.tunnel_options_specification
    iterator = tunnel
    content {
      tunnel_index         = tostring(tunnel.key + 1)
      customer_gateway_id  = alicloud_vpn_customer_gateway.this[tunnel.value.customer_gateway_key].id
      enable_nat_traversal = tunnel_options_specification.value.enable_nat_traversal
      enable_dpd           = tunnel_options_specification.value.enable_dpd
      
      dynamic "tunnel_ike_config" {
        for_each = tunnel_options_specification.value.tunnel_ike_config
        content {
          ike_auth_alg = tunnel_ike_config.value.ike_auth_alg
          local_id     = tunnel_ike_config.value.local_id
          remote_id    = tunnel_ike_config.value.remote_id
          ike_version  = tunnel_ike_config.value.ike_version
          ike_mode     = tunnel_ike_config.value.ike_mode
          ike_lifetime = tunnel_ike_config.value.ike_lifetime
          psk          = tunnel_ike_config.value.psk
          ike_pfs      = tunnel_ike_config.value.ike_pfs
          ike_enc_alg  = tunnel_ike_config.value.ike_enc_alg
        }
      }
      
      dynamic "tunnel_bgp_config" {
        for_each = tunnel_options_specification.value.tunnel_bgp_config
        content {
          local_asn    = tunnel_bgp_config.value.local_asn
          tunnel_cidr  = tunnel_bgp_config.value.tunnel_cidr
          local_bgp_ip = tunnel_bgp_config.value.local_bgp_ip
        }
      }
      
      dynamic "tunnel_ipsec_config" {
        for_each = tunnel_options_specification.value.tunnel_ipsec_config
        content {
          ipsec_pfs      = tunnel_ipsec_config.value.ipsec_pfs
          ipsec_enc_alg  = tunnel_ipsec_config.value.ipsec_enc_alg
          ipsec_auth_alg = tunnel_ipsec_config.value.ipsec_auth_alg
          ipsec_lifetime = tunnel_ipsec_config.value.ipsec_lifetime
        }
      }
    }
  }
}
