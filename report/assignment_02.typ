= Assignment: DVWA Command Execution (Injection) <assignment-2>

== Overview and Definitions

This penetration testing assignment uses the same DVWA target as the previous XSS assignment, but focuses on a different vulnerability type: command injection. The key source I used for this was a book _Linux Shell Scripting for Hackers_ by Valentine Nachi and Donald Tevault (Packt Publishing, 2026), especially Chapter 5 on _Automating Web Application Attacks_. Inside that chapter, there is a section titled _Operating system command injection automation_. The book states that _"If a web app doesn’t properly sanitize user input, it might be possible for a hacker to execute shell commands on the web server."_.

== Target Setup and Relevant Code

The penetration was started by launching the DVWA using TIM platform. The ip address ended up being the same as yesterday: `193.167.189.112`, as well as the credentials, but port is `2785` this time. Once again, I logged in with `admin:jksouran81169` and then navigated to the Command Injection page. The vulnerable field asks for an IP address to ping. I was able to ping Google DNS `8.8.8.8` succesfully, as well as the `localhost`, even though that it not an IP but a hostname. Once again, I am given the access to the source code, meaning that I am gray-box testing. The PHP code is, when simplified by removing some unrelated logic, is as follows:

```php
<?php

if( isset( $_POST[ 'Submit' ]  ) ) {
    // Get input
    $target = $_REQUEST[ 'ip' ];

    // OS determination snipped out.
    $cmd = shell_exec( 'ping  -c 4 ' . $target );

    // Feedback for the end user
    echo "<pre>{$cmd}</pre>";
}

?>
```

== Observations

The PHP does not perform any input validation or sanitization, and directly concatenates the user input into a shell command. This makes this vulnerability *CRITICAL*. I can simply end the current command with a semicolon or double ampersand and then add any arbitrary command I want. In this assignment, I need to:

1. Find a "secret" file.
2. Use `runme_*.sh` script to decrypt the contents.

The first step was to try to find the file. I used `pwd` to figure out where I am in (`/app/vulnerabilities/exec`) and then `ls -lA` to list the files. The secret file is not in that directory. Thus, I ran `find / -name "secret"` and got the path: `/etc/secret`. I used same logic to find the `runme*` file, which was found to be `/bin/runme_66383151.sh`. To check the contents, I typed the following command into the input field:

```
localhost; cat /etc/secret /bin/runme_66383151.sh
```

The secret is clearly a base64 encoded string. The provided shell script simply decodes the string. I tried to run it by passing the path to the secret file as an argument:

```bash
localhost; /bin/runme_66383151.sh /etc/secret 2>&1

localhost; chown $USER /bin/runme_66383151.sh 2>&1
```

The command didn't output anything, so I added the redirection of stderr to stdout, as can be seen in the command above. The error was _permission denied_. Also, changing the permissions of the shell script to be executable didn't work. Neither did `chown`. Thus, I simply used the `base64` command to decode the secret.

== Assignment Solution

As explained in the observations, the solution is to use the `base64` command to decode the secret file. The final command that I typed into the input field was:

```
localhost; base64 -d /etc/secret
```

The output was: `af9e368d0096b607cbadaba809c03510c2b1a1a3`. This is the secret that I was looking for.

The impact of this vulnerability is, as mentioned before, *CRITICAL*. The user is not in sudoers and has limited permissions, but the attacker can use still retrieve sentisive information. Also, as of yesterday (2025-04-29), there is a zero-day CopyFail vulnerability (CVE-2026-31431) that allows privilage escalation. I actually considered trying this, but there is no `curl` installed. Also, that wouldn't be a good practice, since it is beyond what has been allowed in the assignment brief.