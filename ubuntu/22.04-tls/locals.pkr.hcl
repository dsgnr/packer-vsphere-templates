locals {
  vm_name       = "${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-v${local.build_version}"
  build_by      = "Built by: HashiCorp Packer ${packer.version}"
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version = formatdate("MMDD.hhmm", timestamp())
}
