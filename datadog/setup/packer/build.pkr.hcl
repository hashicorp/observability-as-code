# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "project_id" {
  type    = string
  default = ""
}

variable "zone" {
  type    = string
  default = ""
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "googlecompute" "ubuntu" {
  image_labels = {
    created = "${local.timestamp}"
  }
  image_name          = "datadog-ecommerce"
  project_id          = "${var.project_id}"
  source_image_family = "ubuntu-1804-lts"
  ssh_username        = "root"
  zone                = "${var.zone}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.googlecompute.ubuntu"]

  provisioner "file" {
    destination = "/tmp/google-startup-scripts.service"
    source      = "resources/google-startup-scripts.service"
  }

  provisioner "file" {
    destination = "/lib/systemd/system/gor.service"
    source      = "resources/gor.service"
  }

  provisioner "shell" {
    script = "bootstrap.sh"
  }
}
