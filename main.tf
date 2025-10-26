resource "alicloud_vpn_customer_gateway" "this" {
  for_each = var.customer_gateways
  
  ip_address            = each.value.ip_address
  customer_gateway_name = each.value.name
}

# Create VPN Gateway Attachments
resource "alicloud_vpn_gateway_vpn_attachment" "this" {
  for_each = var.vpn_gateways
  
  network_type        = each.value.network_type
  local_subnet        = join(",", each.value.local_subnets)
  remote_subnet       = join(",", each.value.remote_subnets)
  enable_tunnels_bgp  = each.value.enable_tunnels_bgp
  vpn_attachment_name = each.value.attachment_name
  
   # Master tunnel (tunnel 1)
  tunnel_options_specification {
    tunnel_index         = "1"
    customer_gateway_id  = alicloud_vpn_customer_gateway.this[each.value.tunnel_options_specification[0].customer_gateway_key].id
    enable_nat_traversal = lookup(each.value.tunnel_options_specification[0], "enable_nat_traversal", true)
    enable_dpd           = lookup(each.value.tunnel_options_specification[0], "enable_dpd", true)
    
    dynamic "tunnel_ike_config" {
      for_each = length(each.value.tunnel_options_specification[0].tunnel_ike_config) > 0 ? each.value.tunnel_options_specification[0].tunnel_ike_config : []
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
      for_each = length(each.value.tunnel_options_specification[0].tunnel_bgp_config) > 0 ? each.value.tunnel_options_specification[0].tunnel_bgp_config : []
      content {
        local_asn    = tunnel_bgp_config.value.local_asn
        tunnel_cidr  = tunnel_bgp_config.value.tunnel_cidr
        local_bgp_ip = tunnel_bgp_config.value.local_bgp_ip
      }
    }
    
    dynamic "tunnel_ipsec_config" {
      for_each = length(each.value.tunnel_options_specification[0].tunnel_ipsec_config) > 0 ? each.value.tunnel_options_specification[0].tunnel_ipsec_config : []
      content {
        ipsec_pfs      = tunnel_ipsec_config.value.ipsec_pfs
        ipsec_enc_alg  = tunnel_ipsec_config.value.ipsec_enc_alg
        ipsec_auth_alg = tunnel_ipsec_config.value.ipsec_auth_alg
        ipsec_lifetime = tunnel_ipsec_config.value.ipsec_lifetime
      }
    }
  }

  # Slave tunnel (tunnel 2) - required for redundancy
  tunnel_options_specification {
    tunnel_index         = "2"
    customer_gateway_id  = alicloud_vpn_customer_gateway.this[each.value.tunnel_options_specification[0].customer_gateway_key].id
    enable_nat_traversal = lookup(each.value.tunnel_options_specification[0], "enable_nat_traversal", true)
    enable_dpd           = lookup(each.value.tunnel_options_specification[0], "enable_dpd", true)
    
    dynamic "tunnel_ike_config" {
      for_each = length(each.value.tunnel_options_specification[0].tunnel_ike_config) > 0 ? each.value.tunnel_options_specification[0].tunnel_ike_config : []
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
      for_each = length(each.value.tunnel_options_specification[0].tunnel_bgp_config) > 0 ? each.value.tunnel_options_specification[0].tunnel_bgp_config : []
      content {
        local_asn    = tunnel_bgp_config.value.local_asn
        tunnel_cidr  = tunnel_bgp_config.value.tunnel_cidr_slave  # Use a different CIDR for slave tunnel
        local_bgp_ip = tunnel_bgp_config.value.local_bgp_ip_slave # Use a different IP for slave tunnel
      }
    }
    
    dynamic "tunnel_ipsec_config" {
      for_each = length(each.value.tunnel_options_specification[0].tunnel_ipsec_config) > 0 ? each.value.tunnel_options_specification[0].tunnel_ipsec_config : []
      content {
        ipsec_pfs      = tunnel_ipsec_config.value.ipsec_pfs
        ipsec_enc_alg  = tunnel_ipsec_config.value.ipsec_enc_alg
        ipsec_auth_alg = tunnel_ipsec_config.value.ipsec_auth_alg
        ipsec_lifetime = tunnel_ipsec_config.value.ipsec_lifetime
      }
    }
  }
}