= Extra Activity: Mini-LAB for Pentesting <assignment-extra>

#import "@preview/gentle-clues:1.3.0": info

The video can be watched in YouTube following the link: #link("https://youtu.be/y0AN1tnZok8")[KYBS2001 Penetration Testing ExtraActivity Brutus Mini-Lab]

All the code, and also the Typst source for this report can be found in the GitHub repository: #link("https://github.com/sourander/KYBS2001-penetration-testing")[gh:sourander/KYBS2001-penetration-testing].

In the Mini-Lab, I set up two mini-labs. The first one fullfills the requirements of the assignment, and the second one is a stub that I did to feed my curiosity. They are:

*mini-lab*

- Has 3 vulnerable services: SSH, HTTP (nginx) with Basic Auth, and PostgreSQL.
- Vulnerability is a weak password.
- Docker Compose is used to set up all the services.
- Has a bastion host with Brutus installed and configured to run the scans and exploits.

*mini-lab-v2*

- Has only 1 service: SSH
- Vulnerability is a weak password PLUS no fail2ban nor the built-in OpenSSH proection against brute-force attacks (PerSourcePenalties).
- Canonical Multipass is used to set up all the services.
- Tools are installed and configured using Cloud-Init.
- Has a bastion host with Brutus installed and configured to run the scans and exploits.

The latter is an extra-extra task, so scope was left to be very narrow. SSH secure server has no Justfile command; if more time was spent on this, I would implement steps that would display the IP tables rules and fail2ban status. The resulting YouTube video is already 4 minutes long, and a 2 minute or-so video was hoped, so I decided to drop this. However, figuring out the `PerSourcePenalties` was interesting. I had no idea such default configuration exists. My quick way of hardening OpenSSH on Ubuntu has usually been fail2ban or ufw with rate limit. Also, I pretty much never use password, but key-based authentication.

An interesting extension to this would be to look into fail2ban settings, and identify potential poor configurations in the default config (`/etc/fail2ban/jail.conf`). Alternative would be to install an old, vulnerable version of a chosen service, and then exploit it. However, this was already done during the course using the DVWA and in the O'Reilly course I watched on the side.
