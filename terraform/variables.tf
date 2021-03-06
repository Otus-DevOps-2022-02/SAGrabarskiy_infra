variable "cloud_id" {}
variable "folder_id" {}
variable "yc_instance_zone" { default = "ru-central1-a" }
variable "public_key_path" {}
variable "private_key_path" {}
variable "image_id" {}
variable "subnet_id" {}
variable "service_account_key_file" { default = "key.json" }
variable "target_port" { default = "9292" }
variable "lb_port" { default = "80" }
variable "access_key" {}
variable "secret_key" {}
variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-base-app"
}
variable "db_disk_image" {
  description = "Disk image for reddit db"
  default     = "reddit-base-db"
}
