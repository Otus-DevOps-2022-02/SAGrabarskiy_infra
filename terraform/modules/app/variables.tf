variable "public_key_path" {}
variable "private_key_path" {}
variable "subnet_id" {}
variable "reddit_app_name" {}
variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-base-app"
}
variable "database_ip" {}
