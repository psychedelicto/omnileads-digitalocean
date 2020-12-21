# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
#
resource "digitalocean_firewall" "fw_omlapp" {
  name = var.name_omlapp

  droplet_ids = [module.droplet_omlapp.id[0]]
  tags   = [digitalocean_tag.tenant.id,digitalocean_tag.env.id]

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
    protocol                  = "tcp"
    port_range                = "5038"
    source_droplet_ids        = [module.droplet_wombat.id[0]]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "5161"
    source_addresses = ["190.19.150.8"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "40000-50000"
    source_addresses = ["190.19.150.8"]
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
  name = var.name_rtpengine

  droplet_ids = [module.droplet_rtpengine.id[0]]
  tags   = [digitalocean_tag.tenant.id,digitalocean_tag.env.id]

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


# Firewall aplicado al droplet WOMBAT # Firewall aplicado al droplet WOMBAT
# Firewall aplicado al droplet WOMBAT # Firewall aplicado al droplet WOMBAT
# Firewall aplicado al droplet WOMBAT # Firewall aplicado al droplet WOMBAT
# Firewall aplicado al droplet WOMBAT # Firewall aplicado al droplet WOMBAT
# Firewall aplicado al droplet WOMBAT # Firewall aplicado al droplet WOMBAT


resource "digitalocean_firewall" "fw_wombat" {
  name = var.name_wombat

  droplet_ids = [module.droplet_wombat.id[0]]
  tags   = [digitalocean_tag.tenant.id,digitalocean_tag.env.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol            = "tcp"
    port_range          = "8080"
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



# Firewall aplicado al cluster PGSQL # Firewall aplicado al cluster PGSQL
# Firewall aplicado al cluster PGSQL # Firewall aplicado al cluster PGSQL
# Firewall aplicado al cluster PGSQL # Firewall aplicado al cluster PGSQL

resource "digitalocean_database_firewall" "pgsql-fw" {
  cluster_id = module.pgsql.database_id

  rule {
    type  = "droplet"
    value = module.droplet_omlapp.id[0]
  }
}


# Firewall aplicado al cluster REDIS # Firewall aplicado al cluster REDIS
# Firewall aplicado al cluster REDIS # Firewall aplicado al cluster REDIS
# Firewall aplicado al cluster REDIS # Firewall aplicado al cluster REDIS

resource "digitalocean_firewall" "fw_redis" {
  name = var.name_redis

  droplet_ids = [module.droplet_wombat.id[0]]
  tags   = [digitalocean_tag.tenant.id,digitalocean_tag.env.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol            = "tcp"
    port_range          = "6379"
    source_droplet_ids  = [module.droplet_omlapp.id[0]]
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
