default:
    @just --list

# Start the lab
up:
    docker compose -f mini-lab/compose.yml up -d --build

# Interactive Bastion access
connect:
    docker compose -f mini-lab/compose.yml exec -w /scripts bastion bash

# THOU SHALL... ok, you can go.
exploit-vulnerable:
    docker compose -f mini-lab/compose.yml exec bastion bash /scripts/exploit.sh ssh-vulnerable ssh
    docker compose -f mini-lab/compose.yml exec bastion bash /scripts/exploit.sh http-vulnerable http
    docker compose -f mini-lab/compose.yml exec bastion bash /scripts/exploit.sh postgres-vulnerable postgresql

# THOU SHALT NOT PASS!
exploit-secure:
    -docker compose -f mini-lab/compose.yml exec bastion bash /scripts/exploit.sh ssh-secure ssh
    -docker compose -f mini-lab/compose.yml exec bastion bash /scripts/exploit.sh http-secure http
    -docker compose -f mini-lab/compose.yml exec bastion bash /scripts/exploit.sh postgres-secure postgresql

# Bulldoze everything
teardown:
    docker compose -f mini-lab/compose.yml down -v --remove-orphans