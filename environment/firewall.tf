<<<<<<< HEAD
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp

resource "digitalocean_firewall" "fw_omlapp" {
  name = "omnileadsApp"

  droplet_ids = [module.droplet_omlapp.id[0]]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "443"
    source_load_balancer_uids = [module.lb.lb_id]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "5161"
    source_addresses = ["190.19.150.8","143.110.147.48"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "40000-50000"
    source_addresses = ["190.19.150.8","143.110.147.48"]
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

  outbound_rule {
  protocol              = "icmp"
  destination_addresses = ["0.0.0.0/0", "::/0"]
}
}

# Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine


resource "digitalocean_firewall" "fw_rtpengine" {
  name = "rtpengine"

  droplet_ids = [module.droplet_rtpengine.id[0]]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol            = "tcp"
    port_range          = "22222"
    source_droplet_ids  = [module.droplet_omlapp.id[0]]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "20000-50000"
    source_addresses = ["0.0.0.0/0"]
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

  outbound_rule {
  protocol              = "icmp"
  destination_addresses = ["0.0.0.0/0", "::/0"]
}
}
=======
# # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
#
# resource "digitalocean_firewall" "fw_omlapp" {
#   name = "omnileadsApp"
#
#   droplet_ids = [module.droplet_omlapp.id[0]]
#
#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "22"
#     source_addresses = ["0.0.0.0/0"]
#   }
#
#   inbound_rule {
#     protocol                  = "tcp"
#     port_range                = "443"
#     source_load_balancer_uids = [module.lb.lb_id]
#   }
#
#   inbound_rule {
#     protocol         = "udp"
#     port_range       = "5161"
#     source_addresses = ["190.19.150.8","143.110.147.48"]
#   }
#
#   inbound_rule {
#     protocol         = "udp"
#     port_range       = "40000-50000"
#     source_addresses = ["190.19.150.8","143.110.147.48"]
#   }
#
#   outbound_rule {
#     protocol              = "tcp"
#     port_range            = "1-65535"
#     destination_addresses = ["0.0.0.0/0", "::/0"]
#   }
#
#   outbound_rule {
#     protocol              = "udp"
#     port_range            = "1-65535"
#     destination_addresses = ["0.0.0.0/0", "::/0"]
#   }
#
#   outbound_rule {
#   protocol              = "icmp"
#   destination_addresses = ["0.0.0.0/0", "::/0"]
# }
# }
#
# # Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# # Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# # Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# # Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# # Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
# # Firewall aplicado al droplet rtpengine # Firewall aplicado al droplet rtpengine
#
#
# resource "digitalocean_firewall" "fw_rtpengine" {
#   name = "rtpengine"
#
#   droplet_ids = [module.droplet.id[0]]
#
#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "22"
#     source_addresses = ["0.0.0.0/0"]
#   }
#
#   inbound_rule {
#     protocol            = "tcp"
#     port_range          = "22222"
#     source_droplet_ids  = [module.droplet_omlapp.id[0]]
#   }
#
#   inbound_rule {
#     protocol         = "udp"
#     port_range       = "20000-50000"
#     source_addresses = ["0.0.0.0/0"]
#   }
#
#
#   outbound_rule {
#     protocol              = "tcp"
#     port_range            = "1-65535"
#     destination_addresses = ["0.0.0.0/0", "::/0"]
#   }
#
#   outbound_rule {
#     protocol              = "udp"
#     port_range            = "1-65535"
#     destination_addresses = ["0.0.0.0/0", "::/0"]
#   }
#
#   outbound_rule {
#   protocol              = "icmp"
#   destination_addresses = ["0.0.0.0/0", "::/0"]
# }
# }
>>>>>>> redis y pgsql pendiente
