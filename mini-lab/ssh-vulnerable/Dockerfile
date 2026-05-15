FROM ubuntu:22.04

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Create the target user with a WEAK password present in wordlists/passwords.txt
RUN useradd -m -s /bin/bash pentest && \
    echo 'pentest:password' | chpasswd

# Explicitly allow password authentication (guards against cloud-init overrides)
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Required runtime directory for sshd
RUN mkdir -p /run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
