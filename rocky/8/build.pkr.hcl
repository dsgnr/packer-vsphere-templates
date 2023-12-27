build {
  sources = ["source.vsphere-iso.vsphere_source"]

  provisioner "file" {
    source      = "${var.vm_guest_os_name}/${var.vm_guest_os_version}/scripts/bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  # Wait till cloud-init has completed before final cleanup steps
  provisioner "shell" {
    inline = ["sudo bash /tmp/bootstrap.sh; rm -f /tmp/bootstrap.sh"]
  }
}
