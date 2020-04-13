terraform {
  required_version = "~>0.12"
}

variable "dd_api_key" {}

provider "google" {
  version = "~> 3.16"
  zone    = "us-central1-a"
}

data "google_compute_network" "default" {
  name = "default"
}

// resource "google_compute_firewall" "ecommerce" {
//   name    = "allow-ecommerce"
//   network = "default"

//   allow {
//     protocol = "tcp"
//     ports    = ["3000"]
//   }
// }

resource "google_compute_instance" "default" {
  name         = "datadog-webinar-ecommerce"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["datadog", "webinar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    partner = "datadog"
    purpose = "webinar"
  }

  metadata_startup_script = <<EOT
    sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo apt-get -y install git wget
    git clone https://github.com/DataDog/ecommerce-workshop.git
    cd ecommerce-workshop
    sudo curl -L https://github.com/buger/goreplay/releases/download/v1.0.0/gor_1.0.0_x64.tar.gz -o gor_1.0.0_x64.tar.gz
    tar -xf gor_1.0.0_x64.tar.gz
    sudo mv gor /usr/local/bin/gor
    rm -rf gor_1.0.0_x64.tar.gz
    cd docker-compose-files
    POSTGRES_USER=postgres POSTGRES_PASSWORD=postgres DD_API_KEY=${var.dd_api_key} docker-compose -f docker-compose-fixed-instrumented.yml up -d
  EOT

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}