variable "cloud_id" {}
variable "folder_id" {}
variable "yc_instance_zone" { default = "ru-central1-a" }
variable "public_key_path" {}
variable "private_key_path" {}
variable "image_id" {}
variable "subnet_id" {}
variable "reddit_app_name" {}
variable "reddit_db_name" {}
variable "service_account_key_file" { default = "key.json" }
variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-base-app"
}
variable "db_disk_image" {
  description = "Disk image for reddit db"
  default     = "reddit-base-db"
}
variable "access_key" {}
variable "secret_key" {}
