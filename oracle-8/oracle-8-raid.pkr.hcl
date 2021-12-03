# Name
variable "vm_name" {
  type    = string
  default = "oracle-8-raid"
}

# Hyper-V variables
variable "switch_name" {
  type    = string
  default = "Default Switch"
}

# VMware variables
variable "host" {
  type    = string
  default = "192.168.101.7"
}
variable "remote_username" {
  type    = string
  default = "root"
}
variable "remote_password" {
  type    = string
  default = "INSERT-PASSWORD"
}
variable "remote_datastore" {
  type    = string
  default = "datastore1"
}
variable "guest_os_type" {
  type    = string
  default = "oraclelinux-64"
}

# Modify ISO variables to correspond to your downloaded ISO.
# Under Windows you can calculate the SHA1 hash this:
#    certutil -HashFile [OracleLinux-R8-U5-x86_64-dvd.iso] SHA256
variable "iso_checksum" {
  type    = string
  default = "sha256:45939e85542c19dd519aaad7c4dbe84a6fcadfaca348245f92ae4472fc7f50ac"
}
variable "iso_url" {
  type    = string
  default = "file://C:/path/to/ISOs/OracleLinux-R8-U5-x86_64-dvd.iso"
}

# Tell Packer where to store the build artifacts
variable "output_directory" {
  type    = string
  default = "T:/packer-builds"
}

# SSH connection details. If you change the password you MUST also change the
# password in http/ks.cfg.
variable "ssh_password" {
  type    = string
  default = "changeThisPassword"
}
variable "ssh_username" {
  type    = string
  default = "ansible"
}

# Tweak VM resources to suit your needs for the image
variable "cpus" {
  type    = string
  default = "2"
}
variable "disk_size" {
  type    = string
  default = "40960"
}
variable "memory" {
  type    = string
  default = "2048"
}

# The most likely things that will need tweaking in the source sections below
# are the boot_command and the boot_wait period.
source "hyperv-iso" "oraclelinux_8_raid" {
  boot_command = [
    "<esc><esc><esc>clinuxefi /images/pxeboot/vmlinuz ",
    "inst.stage2=hd:LABEL=OL-8-5-0-BaseOS-x86_64 quiet ",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>",
    "initrdefi /images/pxeboot/initrd.img<enter>", "boot<enter>"
  ]
  boot_wait             = "3s"
  communicator          = "ssh"
  cpus                  = "${var.cpus}"
  disk_additional_size  = ["${var.disk_size}"]
  disk_block_size       = 32
  disk_size             = "${var.disk_size}"
  enable_dynamic_memory = true
  enable_secure_boot    = true
  first_boot_device     = "SCSI:0:2"
  generation            = 2
  headless              = false
  http_directory        = "http"
  iso_checksum          = "${var.iso_checksum}"
  iso_url               = "${var.iso_url}"
  memory                = "${var.memory}"
  output_directory      = "${var.output_directory}/${var.vm_name}"
  secure_boot_template  = "MicrosoftUEFICertificateAuthority"
  shutdown_command      = "echo '${var.ssh_username}' | sudo -S shutdown -P now"
  ssh_password          = "${var.ssh_password}"
  ssh_timeout           = "20m"
  ssh_username          = "${var.ssh_username}"
  switch_name           = "${var.switch_name}"
  vm_name               = "${var.vm_name}"
}

source "vmware-iso" "oraclelinux_8_raid" {
  boot_command = [
    "i<tab><wait> ",
    "inst.text ",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks-raid.cfg<enter>"
  ]
  boot_wait            = "3s"
  communicator         = "ssh"
  cpus                 = "${var.cpus}"
  disk_additional_size = ["${var.disk_size}"]
  disk_size            = "${var.disk_size}"
  disk_type_id         = "thin"
  guest_os_type        = "${var.guest_os_type}"
  http_directory       = "http"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = "${var.memory}"
  network_adapter_type = "vmxnet3"
  network_name         = "VM Network"
  output_directory     = "${var.output_directory}/${var.vm_name}"
  remote_datastore     = "${var.remote_datastore}"
  remote_host          = "${var.host}"
  remote_password      = "${var.remote_password}"
  remote_type          = "esx5"
  remote_username      = "${var.remote_username}"
  shutdown_command     = "echo '${var.ssh_username}' | sudo -S shutdown -P now"
  ssh_password         = "${var.ssh_password}"
  ssh_timeout          = "20m"
  ssh_username         = "${var.ssh_username}"
  vm_name              = "${var.vm_name}"
  vmdk_name            = "${var.vm_name}"
  vnc_disable_password = true
}

build {
  name = "oraclelinux-8"
  sources = [
    "source.hyperv-iso.oraclelinux_8_raid",
    "source.vmware-iso.oraclelinux_8_raid"
  ]

  provisioner "shell" {
    execute_command = "echo '${var.ssh_username}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "scripts/set_up_ssh.sh",
      "scripts/clean_up.sh"
    ]
  }

}
