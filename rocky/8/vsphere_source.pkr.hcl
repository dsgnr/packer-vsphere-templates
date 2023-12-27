source "vsphere-iso" "vsphere_source" {
  # Connection Configuration
  vcenter_server      = "${var.vcenter_server}"
  username            = "${var.vsphere_username}"
  password            = "${var.vsphere_password}"
  insecure_connection = "${var.vsphere_insecure_connection}"
  datacenter          = "${var.vsphere_datacenter}"

  # Location Configuration
  vm_name   = local.vm_name
  folder    = "${var.vsphere_template_dir}"
  cluster   = "${var.vsphere_cluster}"
  datastore = "${var.vsphere_datastore}"

  # Hardware Configuration
  CPUs     = "${var.vm_cpu_cores}"
  RAM      = "${var.vm_mem_size}"
  firmware = "${var.vm_firmware}"

  # Enable nested hardware virtualization for VM. Defaults to false.
  NestedHV = "false"

  # Shutdown Configuration
  shutdown_command = "sudo shutdown -P now"

  # ISO Configuration
  iso_checksum = "${var.vm_guest_iso_checksum}"
  iso_url      = "${var.vm_guest_iso_url}"

  # VM Configuration
  guest_os_type = var.vm_guest_os_type
  notes         = "Version: v${local.build_version}\nBuilt on: ${local.build_date}\n${local.build_by}\nDefault username: ${var.admin.username}\nDefault password: ${var.admin.password}"

  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size             = "${var.vm_disk_size}"
    disk_thin_provisioned = "${var.vm_disk_thin_provisioned}"
  }

  network_adapters {
    network      = "${var.vsphere_network}"
    network_card = "${var.vm_network_card}"
  }

  cd_label = "CIDATA"
  cd_content = {
    "ks.cfg" = templatefile("./data/ks.cfg.tpl", {
      hostname    = local.vm_name
      subnets     = var.vm_guest_os_network_addresses
      netmask     = var.vm_guest_os_network_netmask
      gateway     = var.vm_guest_os_network_gateway
      dns_servers = join(",", var.vm_guest_os_network_dns)
      username    = var.admin.username
      password    = var.admin.password_encrypted
      language    = var.vm_guest_os_language
      keyboard    = var.vm_guest_os_keyboard
      timezone    = var.vm_guest_os_timezone
    }),
  }

  // Boot & Provisioning
  ip_wait_timeout = "30m"
  boot_order      = "disk,cdrom"
  boot_wait       = "5s"
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    " text inst.ks=cdrom:/dev/sr1:/ks.cfg",
    "<leftCtrlOn>x<leftCtrlOff>"
  ]

  // Communication
  communicator              = "ssh"
  ssh_timeout               = "30m"
  ssh_port                  = 22
  ssh_handshake_attempts    = "1000"
  ssh_username              = var.admin.username
  ssh_password              = var.admin.password
  ssh_clear_authorized_keys = true

  shutdown_timeout     = "60m"
  tools_upgrade_policy = true
  remove_cdrom         = true

  # Create as template
  convert_to_template = "true"
}

