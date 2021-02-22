#  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet
#  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet #  RTPENGINE componenet

  module "droplet_rtpengine" {
  source             = "github.com/psychedelicto/oml-rtpengine/deploy/digitalocean/infra"
  image_name         = var.img_centos
  name               = var.name_rtpengine
  tenant             = var.tenant
  environment        = var.environment
  # droplet_count      = var.droplet_count
  region             = var.region
  ssh_keys           = [var.ssh_id]
  vpc_uuid           = module.vpc.id
  droplet_size       = var.droplet_rtp_size
  monitoring         = false
  private_networking = true
  user_data          = templatefile("./.terraform/modules/droplet_rtpengine/deploy/digitalocean/cloud-init/user_data.tpl", {
  })
  }

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
