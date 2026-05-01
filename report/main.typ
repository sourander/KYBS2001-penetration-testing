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

#include "assignment_01.typ"

#include "assignment_02.typ"

#include "assignment_03.typ"

#include "assignment_04.typ"

#include "assignment_05.typ"

#include "assignment_06.typ"

#include "assignment_07.typ"

#include "extra_minilab.typ"

= Appendices

== Appendix #1 <appendix-1>

Appendix 1.

== Appendix #2 <appendix-2>

Appendix 2.

