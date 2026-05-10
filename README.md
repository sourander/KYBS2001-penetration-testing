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

## Running the Brutus Mini-LAB

The code for the *ExtraActivity: build mini-lab for AI-pentesting/bruteforcing tools* is in this same repository. It has a brief documentation in the report (see the report guide above), but the code itself is in the `mini-lab` directory. It can be set up with Just by following the steps below:

### Prerequisites

- Docker
- Just

### Get it running

TODO

### Teardown

TODO

## (Off-topic): LAB setup for Kali

During the course, I also watched a video on demand course on O'Reilly platform. I used the Kali running in QEMU/KVM as the distro that I used to connect to the TIM assignment servers. The setup of Kali and other relating memos are in [kali-memo.md](kali-memo.md), but they are not part of the report – they are just for my own reference.

## Usage of AI

I used AI only for reformatting purposes. All other work is mine. The most AI-intensive part was the conversion from LaTeX to Typst. Model used was Github Copilot Pro's GPT-5.4. I prefer Typst over LaTeX, and converting the report template manually would have served no purpose (in this course's context). I also used Github Copilot Pro to e.g. create various scaffolding and template structures, like empty report sections, directory structures, Justfile placeholders, etc.
