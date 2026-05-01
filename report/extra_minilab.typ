= Extra Activity: Mini-LAB for Pentesting <assignment-extra>

#import "@preview/gentle-clues:1.3.0": info

#info[
What/how to deliver:
- code, configs, docs, non-weaponized "test exploit" for demo purposes etc.'
    - ideally github/gitlab/public-git link
    - archived zip containing code
- he code/archive must contain readme.md (in MD format) doc outlining the steps how to run both vulnerable and secured/fixed versions of the lab
- the mini-lab should be ideally run with easy steps/scripts (e.g., git clone ..., ./setup.sh ... , ./run_vuln.sh && ./exploit_test.sh, ./run_secured.sh && ./exploit_test.sh 
- these are just high-level suggestions, you can structure the code/steps/scripts as you wish, but aim for readability + modularity + maintainability + extensibility )
- extra points if you also record+deliver short videos something like up-to 2 minutes (private or public uploads to YouTube or GDrive or FileSender, as you wish) of the lab in all usable situations
- NOTE: the mini-lab should be self-contained, i.e., contain all the download/setup commands, i.e. should not assume that some software/version already exists in the target environment
- Target environment could be bare-bone laptop, bare-bone server, but ideally if possible to have the setup/mini-lab working using docker or VM

Tools

- Brutus (https://github.com/praetorian-inc/brutus)
    - needs to have lab working/demoed with at least "3" different protocols
- Zen-AI-Pentest (https://github.com/SHAdd0WTAka/Zen-Ai-Pentest)
    - needs to have lab working/demoed with at least "2" different real-world/dummy/interntionally-vulnerable targets
- PentestGPT (https://github.com/GreyDGL/PentestGPT)
    - needs to have lab working/demoed with at least "2" different real-world/dummy/interntionally-vulnerable targets
- Shannon (https://github.com/KeygraphHQ/shannon)
    - needs to have lab working/demoed with at least "2" different real-world/dummy/interntionally-vulnerable targets, e.g., two distinct-category vulnerabilities in DVWA
- ToolX: Any tools from here (https://nothingcyber.medium.com/open-source-ai-pentest-red-team-705730238666)
    - needs to have lab working/demoed with at least "2" different real-world/dummy/interntionally-vulnerable targets

In all cases, the targets present/setup MUST also be included in the self-contained lab.
]