variable "public_key_path" {}
variable "private_key_path" {}
variable "subnet_id" {}
variable "reddit_db_name" {}
variable "db_disk_image" {
  description = "Disk image for reddit db"
  default     = "reddit-base-db"
}
