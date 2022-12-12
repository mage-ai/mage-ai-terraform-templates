terraform {
  required_version = ">= 1.2.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {}

resource "digitalocean_ssh_key" "ssh_key" {
  name = "${var.app_name}-${var.app_environment}-key"
  public_key = file(var.ssh_pub_key)
}

resource "digitalocean_droplet" "app" {
  name      = "${var.app_name}-${var.app_environment}"
  image     = "docker-20-04"
  region    = var.region
  size      = "s-${var.cpu}vcpu-${var.memory}gb"
  ssh_keys = [
    digitalocean_ssh_key.ssh_key.id
  ]
}

resource "digitalocean_volume" "volume" {
  region                  = var.region
  name                    = "${var.app_name}-${var.app_environment}-volume"
  size                    = 20
  initial_filesystem_type = "ext4"
}

resource "digitalocean_volume_attachment" "attachment" {
  droplet_id = digitalocean_droplet.app.id
  volume_id  = digitalocean_volume.volume.id
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "digitalocean_firewall" "web" {
  name = "${var.app_name}-${var.app_environment}-firewall"

  droplet_ids = [digitalocean_droplet.app.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6789"
    source_addresses = ["${chomp(data.http.myip.response_body)}/32"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "ip_address" {
  value = digitalocean_droplet.app.ipv4_address
  description = "The public IP address of your Droplet application."
}
