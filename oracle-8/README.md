# Oracle Linux 8 Packer Build
Hyper-V and VMware ESXi (free/standalone) builds. For detailed boot options,
refer to the [RHEL
8](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/performing_an_advanced_rhel_installation/kickstart-and-advanced-boot-options_installing-rhel-as-an-experienced-user)
documentation.

The generated artefacts will be placed in the directory specified by the
`output_directory` variable.

## Hyper-V
This is a UEFI installation. Note that Hyper-V builds require an elevated
command prompt.

## VMware
This is a BIOS-based installation. The VMware builder cannot currently create a
UEFI machine. This is why the `boot_command` stanza differs from Hyper-V's.

Note that `remote_type` must be set to `esx5`, even when targeting ESXi 6+. At
the time of writing, the vmware-iso builder cannot produce ESX 6 images. ESX 5
images will work fine on ESX 6 however.

## Things to change

In `oracle-8.json`:

- Edit everything in the `variables` key to fit your environment and
requirements.
- If you're using a different Oracle 8 ISO, be sure to amend `LABEL` in the
Hyper-V `boot_command` to match. You can derive this by booting your ISO and
editing the boot command in the startup menu.
- You may need to change the `boot_wait` value if you find your build misses
the boot command.

In `http\ks.cfg`:

- Change the initial user if you wish. I use 'ansible' since my next step
is always to run an Ansible playbook.
- Change the password - see notes in the file for one possible method.

The username and password *must* match the settings in `oracle-8.json`,
otherwise Packer won't be able to log in and run provisioners.

In `scripts\set_up_ssh.sh`:

- Set the correct username.
- Insert your public SSH key.

Alternatively, if you don't use SSH keys to log in, just delete the
line from the provisioner in `oracle-8.json`.