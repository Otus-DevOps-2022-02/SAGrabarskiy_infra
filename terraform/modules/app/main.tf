#terraform {
#  required_providers {
#    yandex = {
#      source  = "yandex-cloud/yandex"
#      version = "0.74.0"
#    }
#  }
#  required_version = ">= 0.13"
#}
data "yandex_compute_image" "container-optimized-image-app" {
  name = var.app_disk_image
}
resource "yandex_compute_instance" "app" {
  name   = var.reddit_app_name
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = data.yandex_compute_image.container-optimized-image-app.id
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = var.subnet_id
    nat       = true
  }
  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
  provisioner "file" {
    content     = templatefile("../files/puma.env.tftpl", {database_ip = var.database_ip})
    destination = "/tmp/puma.env"
  }
  provisioner "file" {
    source      = "../files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "../files/deploy.sh"
  }
  provisioner "remote-exec" {
    script = "../files/install_puma_service.sh"
  }
}
