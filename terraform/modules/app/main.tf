resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "null_resource" "app" {
  count = "${var.deploy ? 1 : 0}"

  connection {
    host        = "${element(google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip, 0)}"
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    content     = "${data.template_file.puma_service_tpl.rendered}"
    destination = "/tmp/puma.service"
}

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy-puma.sh"
  }
}

data "template_file" "puma_service_tpl" {
  template = "${file("${path.module}/files/puma.service.tpl")}"

  vars {
    mongo_ext_ip = "${var.mongo_ext_ip}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}

