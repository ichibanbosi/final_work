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
variable "SUBNET_ID_Y" {type = string}


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
   user-data = "#cloud-config\nusers:\n  - name: root\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_rsa.pub")}"
   }

  scheduling_policy {
    preemptible = true
  }

connection {
    type     = "ssh"
    user     = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = yandex_compute_instance.build.network_interface.0.nat_ip_address
  }


  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get install -y python3"
    ]
  }
}

data "yandex_compute_instance" "build" {
    name = "build"
  depends_on = [
   yandex_compute_instance.build
  ]
 }
output "instance_external_ip" {
    value = "${data.yandex_compute_instance.build.network_interface.0.nat_ip_address}"
 }

 resource "yandex_compute_instance" "prod" {
  name        = "prod"
  hostname    = "prod"
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
   user-data = "#cloud-config\nusers:\n  - name: root\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_rsa.pub")}"
   }

  scheduling_policy {
    preemptible = true
  }

connection {
    type     = "ssh"
    user     = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = yandex_compute_instance.build.network_interface.0.nat_ip_address
  }


  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get install -y python3"
    ]
  }
}

data "yandex_compute_instance" "prod" {
    name = "prod"
  depends_on = [
   yandex_compute_instance.prod
  ]
 }
output "instance_external_ip" {
    value = "${data.yandex_compute_instance.build.network_interface.0.nat_ip_address}"
}