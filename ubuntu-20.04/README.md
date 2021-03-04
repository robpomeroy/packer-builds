# Ubuntu 20.04 Packer build for Hyper-V

This is a working UEFI-based installation of Ubuntu 20.04, with a Hyper-V
builder, resulting in a generation 2 virtual machine.

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