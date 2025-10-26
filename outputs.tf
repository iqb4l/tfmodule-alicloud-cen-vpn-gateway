output "customer_gateway_ids" {
  description = "Map of Customer Gateway IDs"
  value = {
    for key, gw in alicloud_vpn_customer_gateway.this :
    key => gw.id
  }
}

output "vpn_gateway_ids" {
  description = "Map of VPN Gateway Attachment IDs"
  value = {
    for key, vpn in alicloud_vpn_gateway_vpn_attachment.this :
    key => vpn.id
  }
}