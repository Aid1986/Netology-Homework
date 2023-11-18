terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_mdb_postgresql_cluster" "netology" {
  name                = "netology"
  environment         = "PRESTABLE"
  network_id          = var.net_id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = "10"
    }
  }

  host {
    zone                = "ru-central1-a"
    subnet_id           = var.subnet_1_id
    assign_public_ip    = true
  }

  host {
    zone                = "ru-central1-b"
    subnet_id           = var.subnet_2_id
    assign_public_ip    = true
  }
}

resource "yandex_mdb_postgresql_database" "test" {
  cluster_id = yandex_mdb_postgresql_cluster.netology.id
  name       = "test"
  owner      = "virtualpostgres"
  depends_on = [
    yandex_mdb_postgresql_user.virtualpostgres
  ]
}

resource "yandex_mdb_postgresql_user" "virtualpostgres" {
  cluster_id = yandex_mdb_postgresql_cluster.netology.id
  name       = "virtualpostgres"
  password   = var.password
}
