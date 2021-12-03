# Name
variable "vm_name" {
  type    = string
  default = "centos-8"
}

# Modify ISO variables to correspond to your downloaded ISO.
# Under Windows you can calculate the SHA1 hash this:
#    certutil -HashFile [CentOS-8.5.2111-x86_64-dvd1.iso] SHA256
variable "iso_checksum" {
  type    = string
  default = "sha256:3b795863001461d4f670b0dedd02d25296b6d64683faceb8f2b60c53ac5ebb3e"
}
variable "iso_url" {
  type    = string
  default = "file://C:/path/to/ISOs/CentOS-8.5.2111-x86_64-dvd1.iso"
}

# Tell Packer where to store the build artifacts
variable "output_directory" {
  type    = string
  default = "T:/packer-builds/centos-8"
}

# SSH connection details. If you change the password you MUST also change the
# password in http/ks.cfg.
variable "ssh_username" {
  type    = string
  default = "ansible"
}
variable "ssh_password" {
  type    = string
  default = "changeThisPassword"
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

# Hyper-V specific configuration - "Default Switch" will work in many cases. I
# use a custom virtual switch though.
variable "switch_name" {
  type    = string
  default = "NAT-Switch"
}

# The most likely things that will need tweaking below are the boot_command and
# the boot_wait period.
source "hyperv-iso" "centos_8" {
  boot_command = [
    "<esc><esc><esc>c",
    "linuxefi /images/pxeboot/vmlinuz ",
    "inst.stage2=hd:LABEL=CentOS-8-5-2111-x86_64-dvd ",
    "quiet inst.text ",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>",
    "initrdefi /images/pxeboot/initrd.img<enter>",
    "boot<enter>"
  ]
  boot_wait             = "3s"
  communicator          = "ssh"
  cpus                  = "${var.cpus}"
  disk_block_size       = 32
  disk_size             = "${var.disk_size}"
  enable_dynamic_memory = true
  enable_secure_boot    = true
  first_boot_device     = "SCSI:0:1"
  generation            = 2
  headless              = false
  http_directory        = "http"
  iso_checksum          = "${var.iso_checksum}"
  iso_url               = "${var.iso_url}"
  memory                = "${var.memory}"
  output_directory      = "${var.output_directory}"
  secure_boot_template  = "MicrosoftUEFICertificateAuthority"
  shutdown_command      = "echo 'ansible' | sudo -S shutdown -P now"
  ssh_password          = "${var.ssh_password}"
  ssh_timeout           = "20m"
  ssh_username          = "${var.ssh_username}"
  switch_name           = "${var.switch_name}"
  vm_name               = "${var.vm_name}"
}

build {
  name    = "centos-8"
  sources = ["source.hyperv-iso.centos_8"]

  provisioner "shell" {
    execute_command = "echo 'ansible' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "scripts/set_up_ssh.sh",
      "scripts/clean_up.sh"
    ]
  }

}
