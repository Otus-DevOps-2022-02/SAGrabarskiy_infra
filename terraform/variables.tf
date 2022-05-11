variable "cloud_id" {}
variable "folder_id" {}
variable "yc_instance_zone" { default = "ru-central1-a" }
variable "public_key_path" {}
variable "private_key_path" {}
variable "image_id" {}
variable "subnet_id" {}
variable "service_account_key_file" { default = "key.json" }
variable "yc_instance_app_count" { default = 1 }
variable "target_port" { default = "9292" }
variable "lb_port" { default = "80" }
