// ─── Page & Typography ────────────────────────────────────────────────────────

#let theme(doc) = {
  set page(
    margin: (left: 25mm, right: 25mm, top: 25mm, bottom: 30mm),
    numbering: none,
    number-align: center,
  )
  set text(font: "New Computer Modern", size: 11pt, hyphenate: false)
  set par(justify: true, leading: 0.72em)
  set heading(numbering: "1.1")
  set enum(numbering: "1.")
  set list(spacing: 1.5em)

  // Math equations: match arkheion weight/spacing
  show math.equation: set text(weight: 400)
  show math.equation: set block(spacing: 0.65em)
  set math.equation(numbering: "(1)")

  show link: underline

  // Headings
  show heading: it => {
    if it.level == 1 {
      pagebreak(weak: true)
      set text(size: 24pt)
      pad(bottom: 10pt, it)
    } else if it.level == 2 {
      pad(bottom: 8pt, it)
    } else if it.level > 3 {
      // Level 4+: run-in subheading
      text(11pt, weight: "bold", it.body + " ")
    } else {
      it
    }
  }

  // Spacing for levels 2 and 3
  show heading.where(level: 2): set block(above: 2.5em, below: 1.2em)
  show heading.where(level: 3): set block(above: 2em, below: 0.5em)

  // Extra margin below figures / captions
  show figure: set block(below: 2em)

  doc
}

// ─── Severity helpers ─────────────────────────────────────────────────────────

#let severity-fill(level) = {
  if level == "Critical" {
    rgb("#7C3AED")
  } else if level == "High" {
    rgb("#DC2626")
  } else if level == "Medium" {
    rgb("#EA580C")
  } else {
    rgb("#CA8A04")
  }
}

#let severity-badge(level) = {
  let fill = severity-fill(level)
  box(
    inset: (x: 8pt, y: 3pt),
    radius: 999pt,
    fill: fill.lighten(65%),
    stroke: (paint: fill, thickness: 0.7pt),
    text(fill.darken(25%), weight: "bold")[#level],
  )
}

// ─── Issue table ──────────────────────────────────────────────────────────────

#let issue-table(
  description,
  cvss,
  exploitability,
  business-impact,
  classifications,
  affected-input,
  affected-output,
) = table(
  columns: (22%, 78%),
  stroke: 0.6pt + rgb("#D1D5DB"),
  inset: 7pt,
  fill: (_, y) => if y == 0 { rgb("#F3F4F6") },
  align: left + horizon,
  table.header(
    [*Field*], [*Details*],
  ),
  [Description], [#description],
  [CVSS Base Score], [#cvss],
  [Exploitability], [#exploitability],
  [Business impact], [#business-impact],
  [References to classifications], [#classifications],
  [Affected input], [#affected-input],
  [Affected output], [#affected-output],
)
