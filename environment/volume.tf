resource "digitalocean_volume" "recordings" {
  region                  = var.region
  name                    = var.recording_device
  size                    = var.disk_recording_size
  initial_filesystem_type = "ext4"
  description             = "recordings"
}

resource "digitalocean_volume_attachment" "omlapp_rec" {
  droplet_id = module.droplet_omlapp.id[0]
  volume_id  = digitalocean_volume.recordings.id
}
