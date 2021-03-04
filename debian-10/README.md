# Debian 10 Packer build for Hyper-V

This is a working UEFI-based installation of Debian, with a Hyper-V builder,
resulting in a generation 2 virtual machine.

## Things to change

In `debian-10.json`:

- Edit everything in the `variables` key to fit your environment and
requirements.
- You may need to change the `boot_wait` value if you find your build misses
the boot command.

In `http\preseed.cfg`:

- Change the initial user if you wish. I use 'ansible' since my next step
is always to run an Ansible playbook.
- Change the password.

The username and password *must* match the settings in `debian-8.json`,
otherwise Packer won't be able to log in and run provisioners.

In `scripts\set_up_ssh.sh`:

- Set the correct username.
- Insert your public SSH key.

Alternatively, if you don't use SSH keys to log in, just delete the
line from the provisioner in `debian-8.json`.