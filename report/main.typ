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

= Executive Summary

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

= Vulnerability Overview

Table @vuln-overview lists the vulnerabilities discovered during the penetration test. The ratings are grouped into low, medium, high, and critical to keep prioritization consistent across the report.

#info(
  "The severity model should be described here in the context of this assessment so that technical and non-technical readers can interpret the findings consistently."
)


#figure(
  image("images/vuln_overview.png", width: 75%),
  caption: [Vulnerability overview],
) <vuln-overview-figure>

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
    [#severity-badge("Critical")], [Domain 1], [Unauthenticated SQL Injection], [@issue-1],
    [#severity-badge("High")], [Domain 1], [Stored XSS], [@issue-2],
    [#severity-badge("Medium")], [Subdomain 1], [Balance manipulation during order confirmation], [@issue-3],
    [#severity-badge("Low")], [Subdomain 2], [Mail server misconfiguration], [@issue-4],
  ),
  caption: [Vulnerability overview],
) <vuln-overview>

= Results

This chapter presents the vulnerabilities found during the penetration test. Findings are grouped by target and include the following information:

- Brief description
- CVSS base score
- Exploitability
- Business impact
- References to classifications such as WASC, OWASP, and CWE
- Steps to reproduce
- Remediation guidance

#info("Also the remediation recommendations are given for each issue found during the
penetration test. Both \"quick win\" and long term solutions are presented as well as
some code examples.")

== Domain 1

System description goes here.

*Hostname:* https://example.com

*Server IP address:* 127.0.0.1

=== Unauthenticated SQL Injection <issue-1>

General vulnerability description goes here.

Basic information about this issue is presented in table @issue-1-table.

#figure(
  issue-table(
    [Description goes here.],
    [8.0],
    [High],
    [Business impact goes here.],
    [[WASC, OWASP]],
    [Affected input goes here.],
    [
      - Output 1
      - Output 2
    ],
  ),
  caption: [Issue #1: description of the issue],
) <issue-1-table>

==== Minimal Proof of Concept

Steps to reproduce the issue go here. Screenshots are welcome.

==== Proposed Solutions

Proposed solution to the issue goes here.

=== Stored XSS <issue-2>

General information about persistent XSS attacks goes here.

Basic information about this issue is presented in table @issue-2-table.

#figure(
  issue-table(
    [Description goes here.],
    [8.0],
    [High],
    [Business impact goes here.],
    [[WASC, OWASP]],
    [Input.],
    [
      - Output 1
      - Output 2
    ],
  ),
  caption: [Issue #2: description of the issue],
) <issue-2-table>

==== Minimal Proof of Concept

Steps to reproduce the issue go here. Screenshots are welcome.

==== Proposed Solutions

Proposed solution to the issue goes here.

== Subdomain 1

System description goes here.

*Hostname:* https://1.example.com

*Server IP address:* 127.0.0.1

=== Balance Manipulation During Order Confirmation <issue-3>

General vulnerability description goes here.

Basic information about this issue is presented in table @issue-3-table.

#figure(
  issue-table(
    [Description goes here.],
    [8.0],
    [High],
    [Business impact goes here.],
    [[WASC, OWASP]],
    [Affected input goes here.],
    [
      - Output 1
      - Output 2
    ],
  ),
  caption: [Issue #3: description of the issue],
) <issue-3-table>

==== Minimal Proof of Concept

Steps to reproduce the issue go here. Screenshots are welcome.

==== Proposed Solutions

Proposed solution to the issue goes here.

== Subdomain 2

System description goes here.

*Hostname:* https://2.example.com

*Server IP address:* 127.0.0.1

=== Mail Server Misconfiguration <issue-4>

General vulnerability description goes here.

Basic information about this issue is presented in table @issue-4-table.

#figure(
  issue-table(
    [Description goes here.],
    [8.0],
    [High],
    [Business impact goes here.],
    [[WASC, OWASP]],
    [Affected input goes here.],
    [
      - Output 1
      - Output 2
    ],
  ),
  caption: [Issue #4: description of the issue],
) <issue-4-table>

==== Minimal Proof of Concept

Steps to reproduce the issue go here. Screenshots are welcome.

==== Proposed Solutions

Proposed solution to the issue goes here.

= Appendices

== Appendix #1 <appendix-1>

Appendix 1.

== Appendix #2 <appendix-2>

Appendix 2.

