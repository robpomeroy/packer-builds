# Packer builds

This repository contains various working Packer builds, based on hours of
head scratching, trial and error and ultimately inexplicable success. As you
have no doubt discovered, one of the fiddliest parts of a Packer build is
working out what incantations are best for a `boot_command`. That may even
be why you're here.

I hope that my efforts will be of help to others (even though this repo may
date quickly). If you spot things that could be improved, feel free to send
me a pull request. There are doubtless many aspects that are less than
optimal. Just don't ask me to change the localisation from en_GB. ;-)

The builds are deliberately minimal, since I use Ansible to configure
machines after provisioning. I only include virtualisation tools and Python,
which is required for Ansible.

The Oracle 8 build is probably the most complete - it offers Hyper-V and
VMware (free ESXi) builds.

## Credits

As you may well have found, getting to a working build involves lots of
internet searching and piecing together snippets of information. I
couldn't possibly reconstruct the names of all those whose own work helped
mine - but thank you all, anyway! In a similar way, please don't feel you
need to credit me if anything here helps you.

Happy Packing!

- Rob

[Twitter](https://twitter.com/robpomeroy) |
[KeyBase](https://keybase.io/robpomeroy) |
[LinkedIn](https://www.linkedin.com/in/robpomeroy/) | 
[website](https://pomeroy.me/)