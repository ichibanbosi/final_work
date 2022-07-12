terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.76.0"
    }
  }
}



variable "TOKEN_Y" {type = string}
variable "CLOUD_ID_Y" {type = string}
variable "FOULDER_ID_Y" {type = string}
variable "SSH_KEY_FOULDER" {type = string}
variable "SUBNET_ID_Y" {type = string}

locals {
  PUB_KEY = "${var.SSH_KEY_FOULDER}/id_rsa.pub"
  PRIV_KEY = "${var.SSH_KEY_FOULDER}/id_rsa"
}

provider "yandex" {
  token     = var.TOKEN_Y
  cloud_id  = var.CLOUD_ID_Y
  folder_id = var.FOULDER_ID_Y
  zone      = "ru-central1-a"
}



resource "yandex_compute_instance" "build" {
  name        = "build"
  hostname    = "build"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
    image_id = "fd8fte6bebi857ortlja"
      size = 15
    }
  }

  network_interface {
    subnet_id = var.SUBNET_ID_Y
    nat = true
  }

 metadata = {
    user-data = "#cloud-config\nusers:\n  - name: root\n  ssh-authorized-keys:\n  - ${file(local.PUB_KEY)}"
  }

  scheduling_policy {
    preemptible = true
  }

connection {
    type     = "ssh"
    user     = "root"
    private_key = "${file(local.PRIV_KEY)}"
    host = yandex_compute_instance.build.network_interface.0.nat_ip_address
  }


  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get install -y python3"
    ]
  }
}