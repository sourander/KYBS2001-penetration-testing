= Extra Activity: Mini-LAB for Pentesting <assignment-extra>

#import "@preview/gentle-clues:1.3.0": info

#info[
What/how to deliver:
- code, configs, docs, non-weaponized "test exploit" for demo purposes. I will submit this as a public GitHub repository link.
- the README.md doc outlining the steps how to run both vulnerable and secured/fixed versions of the lab
- the mini-lab should be ideally run with easy steps/scripts (e.g., git clone ..., just run, just connect, ./exploit-ssh.sh, etc.)
- these are just high-level suggestions, you can structure the code/steps/scripts as you wish, but aim for readability + modularity + maintainability + extensibility )
- extra points if you also record+deliver short videos something like up-to 2 minutes. I will do a YouTube video.
- NOTE: the mini-lab should be self-contained. I will use Docker Compose.

Chosen tools

- Brutus (https://github.com/praetorian-inc/brutus)
  - needs to have lab working/demoed with at least "3" different protocols. I have chosen: 
    - SSH (bad password and one with fail2ban)
    - Grafana (HTTP Basic Auth and one with strong password)
    - PostgreSQL (with default password and one with strong password).
  - I will run two Docker Compose services with hostnames vulnerable and secure. Also, there will be a brutus-bastion that will have the Brutus installed and configured to run the scans and exploits.
]