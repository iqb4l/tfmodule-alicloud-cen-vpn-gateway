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

output "vpn_gateway_details" {
  description = "Complete details of VPN Gateway Attachments"
  value = {
    for key, vpn in alicloud_vpn_gateway_vpn_attachment.this :
    key => {
      id              = vpn.id
      status          = vpn.status
      vpn_gateway_id  = vpn.vpn_gateway_id
      internet_ip     = vpn.internet_ip
    }
  }
}
