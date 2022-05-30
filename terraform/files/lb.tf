resource "yandex_lb_network_load_balancer" "lb-reddit-app" {
  name = "lb-reddit-app"

  listener {
    name        = "listener-redditapp-servers"
    port        = var.lb_port
    target_port = var.target_port
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.redditapp-servers.id

    healthcheck {
      name = "http"
      http_options {
        port = var.target_port
      }
    }
  }
}

locals {
  redditapp-servers-ips = yandex_compute_instance.app.*.network_interface.0.ip_address
}

resource "yandex_lb_target_group" "redditapp-servers" {
  name = "redditapp-servers-target-group"

  dynamic "target" {
    for_each = local.redditapp-servers-ips

    content {
      subnet_id = yandex_vpc_subnet.subnet_terraform.id
      address   = target.value
    }
  }
}
