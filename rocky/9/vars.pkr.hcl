// VCenter Vars
variable "vcenter_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_insecure_connection" {
  type        = bool
  description = "Do not validate vCenter Server TLS certificate"
}

variable "vsphere_datacenter" {
  type        = string
  description = "The name of the target vSphere datacenter. (e.g. 'dc01')"
}

variable "vsphere_template_dir" {
  type        = string
  description = "The name of the target vSphere folder. (e.g. 'templates')"
}

variable "vsphere_cluster" {
  type        = string
  description = "The name of the target vSphere cluster. (e.g. 'prodcl01')"
}

variable "vsphere_datastore" {
  type        = string
  description = "The name of the target vSphere datastore. (e.g. 'vsan01')"
}

variable "vsphere_network" {
  type        = string
  description = "The name of the target vSphere network segment. (e.g. 'hub')"
}

variable "vm_guest_os_network_addresses" {
  type        = list(string)
  description = "The network addresses to assign to the template VM"
}

variable "vm_guest_os_network_netmask" {
  type        = string
  description = "The subnet netmask to assign to the template VM"
}

variable "vm_guest_os_network_gateway" {
  type        = string
  description = "The subnet gateway to assign to the template VM"
}

variable "vm_guest_os_network_dns" {
  type        = list(string)
  description = "The DNS servers to assign to the template VM"
}

variable "vm_guest_apt_mirror_ubuntu" {
  type        = string
  description = "The apt mirror to use for the OS packages"
  default     = "http://archive.ubuntu.com/ubuntu"
}

// Guest Vars
variable "vm_guest_iso_url" {
  type        = string
  description = "The upstream URL of the operating system ISO"
}

variable "vm_guest_iso_checksum" {
  type        = string
  description = "The upstream ISO checksum"
}

variable "vm_guest_os_family" {
  type        = string
  description = "The guest operating system family. Used for naming. (e.g. 'linux')"
}

variable "vm_guest_os_name" {
  type        = string
  description = "The guest operating system name. Used for naming . (e.g. 'ubuntu')"
}

variable "vm_guest_os_version" {
  type        = string
  description = "The guest operating system version. Used for naming. (e.g. '22-04-lts')"
}

variable "vm_guest_os_type" {
  type        = string
  description = "The guest operating system type, also know as guestid."
}

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system lanugage."
  default     = "en_US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "us"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone."
  default     = "UTC"
}

variable "vm_cpu_cores" {
  type        = number
  description = "The number of virtual CPUs cores per socket. (e.g. '1')"
}

variable "vm_mem_size" {
  type        = number
  description = "The size for the virtual memory in MB. (e.g. '2048')"
}

variable "vm_firmware" {
  type        = string
  description = "The virtual machine firmware. (e.g. 'efi-secure'. 'efi', or 'bios')"
  default     = "efi"
}

variable "vm_disk_size" {
  type        = number
  description = "The size for the virtual disk in MB. (e.g. '40960')"
}

variable "vm_network_card" {
  type        = string
  description = "The virtual network card type"
  default     = "vmxnet3"
}

variable "vm_disk_controller_type" {
  type        = list(string)
  description = "The virtual disk controller types in sequence."
  default     = ["pvscsi"]
}

variable "vm_disk_thin_provisioned" {
  type        = bool
  description = "Thin provision the virtual disk."
  default     = true
}

variable "admin" {
  description = "Generate encrypted password: echo \"<PASSWORD>\" | mkpasswd -m sha-512 --rounds=4096 -s"

  type = object({
    username           = string
    password           = string
    password_encrypted = string
    ssh_keys           = set(string)
  })

  default = {
    username           = "sysadmin"
    password           = "rocky"
    password_encrypted = "$6$rounds=4096$Z4sjnv65xTobY.U5$MiZpgvTVEd0XmyfALuSNhzBeMSwX5pmS72TxuGQwXvECsiLFCYDx6idfSi5ETm/S0Wgxm3ZdP7WjUc8YQqK4l1" // rocky
    ssh_keys           = []
  }
}
