# KYBS2001-penetration-testing

## Accessing the report

To build the PDF, type:

```bash
# To launch a live-updating PDF
typst watch report/main.typ

# To build a static PDF once
typst build report/main.typ
```

The rendered PDF file will be located at `report/main.pdf`. It is git ignored, so it won't be committed to the repository.

## Running the Docker Brutus Mini-LAB (mini-lab)

**Note**: A newer Multipass setup is below.

The code for the *ExtraActivity: build mini-lab for AI-pentesting/bruteforcing tools* is in this same repository. It has a brief documentation in the report (see the report guide above), but the code itself is in the `mini-lab` directory. The Brutus documentation is at [Brutus' GitHub repository](https://github.com/praetorian-inc/brutus).

The LAB can be created and destroyed using Just by following the steps below:

### Prerequisites

- [Docker Enginer](https://docs.docker.com/engine/)
- [Just](https://github.com/casey/just)

### Get it running

```
# Launch the Docker Compose stack
just up

# Brute force poor passwords with Brutus
just exploit-vulnerable

# Fail at brute forcing good passwords
just exploit-secure
```

### Teardown

```
# Docker goes boom boom
just teardown
```

## Running the Multipass Brutus Mini-LAB (mini-lab-v2)

This continues the same ExtraActivity as the Docker Brutus Mini-LAB, but it uses Multipass instead of Docker. Reason is to get fail2ban installed easily.

## Prerequisites

- A Linux or macOS host *(Windows requires Hyper-V and thus Windows Pro)*
- [Multipass](https://canonical.com/multipass/install)

### Get it running

```
# Create the VMs
just v2-up

# Brute force poor passwords with Brutus
just v2-exploit-vulnerable

# Out of scope
# just v2-exploit-secure
```

### Teardown

```
# Destroy the VMs
just v2-down
```

## (Off-topic): LAB setup for Kali

During the course, I also watched a video on demand course on O'Reilly platform. I used the Kali running in QEMU/KVM as the distro that I used to connect to the TIM assignment servers. The setup of Kali and other relating memos are in [kali-memo.md](kali-memo.md), but they are not part of the report – they are just for my own reference.

## Usage of AI

I used AI only for reformatting and scaffolding purposes. All other work is mine. The most AI-intensive part was the conversion from LaTeX to Typst. Model used was Github Copilot Pro's GPT-5.4. I prefer Typst over LaTeX, and converting the report template manually would have served no purpose (in this course's context). I also used Github Copilot Pro to e.g. create various scaffolding and template structures, like empty report sections, directory structures, Justfile placeholders, etc.
