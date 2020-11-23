resource "digitalocean_firewall" "default" {

  name        = var.name
  droplet_ids = var.droplet_ids

  dynamic "inbound_rule" {
    iterator = port
    for_each = var.allowed_ports
    content {
      port_range       = port.value
      protocol         = var.protocol
      source_addresses = var.allowed_ip
    }
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
