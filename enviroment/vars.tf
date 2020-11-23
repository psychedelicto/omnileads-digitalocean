variable "region" {
  default = "francisco-1"
}
variable "vpc_cidr" {
  default = "172.16.72.0/20"
}
variable "name" {
  default = "sasadada"
}
variable "app" {
   default = "omlapp"
}
variable "env" {
  default = "dev"
}
variable "droplet_count" {
  default = 1
}
variable "ssh_id" {
  default = "77:4e:2e:df:2c:9c:42:78:28:a3:e4:49:9f:4f:e6:07"
}
variable "droplet_size" {
  default = "micro"
}
variable "disk_size" {
  default = 5
}
variable "user_data_rtp" {
  default = "./../user_data/rtpengine.sh"
}
variable "user_data_omlapp" {
  default = "./../user_data/omlapp.sh"
}
variable "droplet_name_rtp" {
  default = "rtpengine"
}
variable "droplet_name_omlapp" {
  default = "omlapp"
}
variable "droplet_id" {
  default = "69535713"
}
