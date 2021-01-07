#  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet
#  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet #  NFS componenet

  resource "digitalocean_volume" "recordings" {
    region                  = var.region
    name                    = var.recording_device
    size                    = var.disk_recording_size
    initial_filesystem_type = "ext4"
    description             = "recordings"
  }

  module "droplet_recordings"  {
    source             = "github.com/psychedelicto/digitalocean-terraform-modules/droplet"
    image_name         = var.img_ubuntu
    name               = var.name_nfs_recordings
    tenant             = var.tenant
    environment        = var.environment
    region             = var.region
    ssh_keys           = [var.ssh_id]
    vpc_uuid           = module.vpc.id
    droplet_size       = var.droplet_rtp_size
    monitoring         = false
    private_networking = true
    ipv6               = false
    user_data          = templatefile("../user_data/nfs_recordings.tpl", {
      dev_name           = var.recording_device
      nfs_clients        = var.vpc_cidr
      })
  }

  resource "digitalocean_volume_attachment" "nfs_recordings" {
    droplet_id = module.droplet_recordings.id[0]
    volume_id  = digitalocean_volume.recordings.id
  }

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
