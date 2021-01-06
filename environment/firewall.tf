# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp
# Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp # Firewall aplicado al droplet omlApp

resource "digitalocean_tag" "tenant" {
  name = var.tenant
}
resource "digitalocean_tag" "environment" {
  name = var.environment
}

resource "digitalocean_firewall" "fw_omlapp" {
  name = var.name_omlapp

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
    protocol                  = "tcp"
    port_range                = "5038"
    source_droplet_ids        = [module.droplet_wombat.id[0]]
  }

  dynamic "inbound_rule" {
    iterator = sip_allowed_ip
    for_each = var.sip_allowed_ip
    content {
      port_range       = "5161"
      protocol         = "udp"
      source_addresses = var.sip_allowed_ip
    }
  }

  dynamic "inbound_rule" {
    iterator = sip_allowed_ip
    for_each = var.sip_allowed_ip
    content {
      port_range       = "40000-50000"
      protocol         = "udp"
      source_addresses = var.sip_allowed_ip
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


# Firewall aplicado MARIADB # Firewall aplicado MARIADB
# Firewall aplicado MARIADB # Firewall aplicado MARIADB
# Firewall aplicado MARIADB # Firewall aplicado MARIADB

resource "digitalocean_firewall" "fw_mariadb" {
  name = var.name_mariadb

  droplet_ids = [module.droplet_wombat.id[0]]


  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol            = "tcp"
    port_range          = "3306"
    source_droplet_ids  = [module.droplet_wombat.id[0]]
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

# Firewall aplicado NFS-RECORDINGS # Firewall aplicado NFS-RECORDINGS
# Firewall aplicado NFS-RECORDINGS # Firewall aplicado NFS-RECORDINGS
# Firewall aplicado NFS-RECORDINGS # Firewall aplicado NFS-RECORDINGS


resource "digitalocean_firewall" "fw_nfs_recordings" {
  name = var.name_nfs_recordings

  droplet_ids = [module.droplet_recordings.id[0]]

  inbound_rule {
    protocol            = "tcp"
    port_range          = "22"
    source_addresses    = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol            = "tcp"
    port_range          = "2049"
    source_droplet_ids  = [module.droplet_omlapp.id[0]]
  }

  inbound_rule {
    protocol            = "udp"
    port_range          = "2049"
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
