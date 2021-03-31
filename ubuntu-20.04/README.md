# Ubuntu 20.04 Packer build for Hyper-V

Hyper-V and VMware ESXi (free/standalone) builds. The generated artefacts
will be placed in the directory specified by the `output_directory`
variable.

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

In `ubuntu-20.04-8.json`:

- Edit everything in the `variables` key to fit your environment and
requirements.
- You may need to change the `boot_wait` value if you find your build misses
the boot command.

In `http\user-data`:

- Change the initial user if you wish. I use 'ansible' since my next step
is always to run an Ansible playbook.
- Change the password - see notes in the file for one possible method.
- Insert your public SSH key or delete the relevant line.

The username and password *must* match the settings in `ubuntu-20.04.json`,
otherwise Packer won't be able to log in and run provisioners.

Note that the `http\meta-data` file needs to exist, even though it's empty.