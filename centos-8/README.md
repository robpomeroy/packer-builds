# CentOS 8 Packer build for Hyper-V

This is a working UEFI-based installation of CentOS, with a Hyper-V builder,
resulting in a generation 2 virtual machine.

## Things to change

In `centos-8.json`:

- Edit everything in the `variables` key to fit your environment and
requirements.
- If you're using a different CentOS 8 ISO, be sure to amend `LABEL` in the
`boot_command` to match. You can derive this by booting your ISO and
editing the boot command in the startup menu.
- You may need to change the `boot_wait` value if you find your build misses
the boot command.

In `http\ks.cfg`:

- Change the initial user if you wish. I use 'ansible' since my next step
is always to run an Ansible playbook.
- Change the password - see notes in the file for one possible method.

The username and password *must* match the settings in `centos-8.json`,
otherwise Packer won't be able to log in and run provisioners.

In `scripts\set_up_ssh.sh`:

- Set the correct username.
- Insert your public SSH key.

Alternatively, if you don't use SSH keys to log in, just delete the
line from the provisioner in `centos-8.json`.