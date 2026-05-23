default:
    @just --list

# Build the Typst docs
docs:
    typst compile report/main.typ

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

# --- MULTIPASS LAB (v2) ---

V2_DIR := "mini-lab-v2"
# Get the absolute path of the current directory for mounting
PWD := `pwd`

# Start the Multipass v2 lab
v2-up:
    @echo "Launching vulnerable SSH host..."
    multipass launch resolute --name ssh-vulnerable --cloud-init {{V2_DIR}}/vulnerable-ssh.yaml
    
    @echo "Launching secure SSH host..."
    multipass launch resolute --name ssh-secure --cloud-init {{V2_DIR}}/secure-ssh.yaml
    
    @echo "Launching Bastion host..."
    multipass launch resolute --name bastion --cloud-init {{V2_DIR}}/bastion.yaml
    
    @echo "Copying local scripts and wordlists into Bastion..."
    multipass transfer --recursive {{V2_DIR}}/scripts/ bastion:/home/ubuntu/scripts
    multipass transfer --recursive {{V2_DIR}}/wordlists/ bastion:/home/ubuntu/wordlists
    
    @echo "Lab is up!"

# Teardown the Multipass v2 lab
v2-down:
    multipass delete --all
    multipass purge

# Interactive Bastion access
v2-connect:
    multipass shell bastion

# Run the exploit from the Bastion against the vulnerable machine
v2-exploit-vulnerable:
    @echo "Executing exploit script from Bastion..."
    multipass exec bastion -- bash /home/ubuntu/scripts/exploit.sh
