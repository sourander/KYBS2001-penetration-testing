= Assignment: NMAP scan <assignment-7>

== Overview and Definitions

This section will document the NMAP scanning assignment. The `nmap` was already used in the Assignmen 6 (see @assignment-6). In this assignment, there is also a given hint to look into what is a device finterprint. In May 2026, this topic is hot, due to the recent reveal of how LinkedIn is using device fingerprinting to track users across the web. This assignment is a good opportunity to explore the topic of device fingerprinting and its implications for privacy and security. This has been lately a lot in the news, for example, at #link("https://thenextweb.com/news/linkedin-browsergate-extension-scanning-privacy-fingerprint")[TNW: LinkedIn is secretly scanning your browser for 6,000 extensions, and you weren’t told].

However, since we are using nmap, the fingerprinting in question is `nmap` fingerprinting. The `nmap`documents this itself at #link("https://nmap.org/book/osdetect-fingerprint-format.html")[NMAP: Understanding an Nmap Fingerprint]. 

== Target Setup and Relevant Code

Once again, the target machine is using the DVWA. I launched the Kali virtual machine and connected to the host using:

```
ssh jksouran@193.167.189.112 -p 2893
```

The `/etc/os-release` file reveals that this is similar or same Debian 10 Buster image as in the previous assignment. Using `ifconfig`, I can tell that this jump host has the IP address `173.0.72.3` in a `/24` network. The `nmap` has a manpage, but I find various cheat sheets useful, like the #link("https://www.stationx.net/nmap-cheat-sheet/")[StationX: NMAP Cheat Sheet]. I started with fast scan, as in the previous assignment:

```
sudo nmap -F 173.0.72.0/24
```

If we ignore the gateway and the host itself, there is only one other host in the network, which is the DVWA machine. This target has an IP address of `173.0.72.2`, hostname `jksouran_meta2_1.jksouran_nmap_lan` and ports 80 (HTTP), 111 (RPC), 5900 (VNC) and 6000 (X11) are open. For the assignment, I needed to perform a bit more comprehensive scan, so I ran the following command, as following assignment tips, cheat sheet and #link("https://learning.oreilly.com/course/the-complete-ethical/9781839210495/")[O'Reilly: The Complete Ethical Hacking Course] memo I have written down. I tried to match the assignment instruction as closely as possible to get full points:

```
sudo nmap -v -sV -T5 -p 1025-65535 173.0.72.2
```

The parameters are as follows:

- `v`: Verbose output. This is my addition to see more details.
- `sV`: Run service detection.
- `T5`: Set timing template to 5 (Insane). This is the fastest timing template.
- `p 1025-65535`: Scan ports from 1025 to 65535.

With these settings, I hit retransmission issues, so I had to lower the timing template to `T4` (Aggressive) to get reliable results. Now the SYN stealh scan was progressing as expected. It did drop probes and ended up increasing send delay, so I suppose the `T3` would not have been a bad choice either. However, with T4, the scan does progress due to `nmap`'s adaptive timing. In total, it took about 22 minutes, after which `nmap` started running the service (or version) detection to 23 ports. This took about 2 minutes. Then, it can NSE (NMAP Scripting Engine) scripts which took only a few seconds. The scan revealed the following open ports:

#figure(
  table(
    columns: (auto, auto, auto, 1fr),
    stroke: 0.6pt + rgb("#D1D5DB"),
    inset: 7pt,
    fill: (_, y) => if y == 0 { rgb("#F3F4F6") },
    align: left + horizon,
    table.header([*Port*], [*State*], [*Service*], [*Version*]),
    [`1099/tcp`],  [open], [rmiregistry], [GNU Classpath grmiregistry],
    [`3632/tcp`],  [open], [distccd],     [distccd v1 ((GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu4))],
    [`5900/tcp`],  [open], [vnc],         [VNC (protocol 3.3)],
    [`6000/tcp`],  [open], [X11],         [(access denied)],
    [`6697/tcp`],  [open], [irc],         [UnrealIRCd],
    [`8787/tcp`],  [open], [drb],         [Ruby DRb RMI (Ruby 1.8; path /usr/lib/ruby/1.8/drb)],
    [`13306/tcp`], [open], [ftp],         [ProFTPD 1.3.1],
    [`13617/tcp`], [open], [mysql],       [MySQL 5.0.51a-3ubuntu5],
    [`16422/tcp`], [open], [ssh],         [OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)],
    [`24330/tcp`], [open], [irc],         [UnrealIRCd],
    [`27730/tcp`], [open], [login],       [],
    [`31355/tcp`], [open], [postgresql],  [PostgreSQL DB 8.3.0 - 8.3.7],
    [`33201/tcp`], [open], [netbios-ssn], [Samba smbd 3.X - 4.X (workgroup: WORKGROUP)],
    [`33625/tcp`], [open], [netbios-ssn], [Samba smbd 3.X - 4.X (workgroup: WORKGROUP)],
    [`34131/tcp`], [open], [smtp],        [Postfix smtpd],
    [`39772/tcp`], [open], [unknown],     [],
    [`41677/tcp`], [open], [rmiregistry], [GNU Classpath grmiregistry],
    [`46381/tcp`], [open], [unknown],     [],
    [`46419/tcp`], [open], [telnet],      [Linux telnetd],
    [`52247/tcp`], [open], [http],        [Apache Tomcat/Coyote JSP engine 1.1],
    [`56595/tcp`], [open], [unknown],     [],
    [`63816/tcp`], [open], [ftp],         [vsftpd 2.3.4],
    [`63979/tcp`], [open], [tcpwrapped],  [],
  ),
  caption: [Open ports discovered by nmap on 173.0.72.2],
)

== Observations

The scan also revealed the following unknown fingerprint:

```
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port46381-TCP:V=7.70%I=7%D=5/10%Time=6A004BED%P=x86_64-pc-linux-gnu%r(N
SF:ULL,2A,"\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20")%r(Gen
SF:ericLines,D6,"\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20\n
SF:\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20\n\x1b\]0;@00d8b
SF:7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20\n\x1b\]0;@00d8b7edcf5a:\x20/\
SF:x07root@00d8b7edcf5a:/#\x20\n\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7
SF:edcf5a:/#\x20")%r(GetRequest,507,"\x1b\]0;@00d8b7edcf5a:\x20/\x07root@0
SF:0d8b7edcf5a:/#\x20GET\x20/\x20HTTP/1\.0\n<HTML>\n<HEAD>\n<TITLE>Directo
SF:ry\x20/</TITLE>\n<BASE\x20HREF=\"file:/\">\n</HEAD>\n<BODY>\n<H1>Direct
SF:ory\x20listing\x20of\x20/</H1>\n<UL>\n<LI><A\x20HREF=\"\./\">\./</A>\n<
SF:LI><A\x20HREF=\"\.\./\">\.\./</A>\n<LI><A\x20HREF=\"\.dockerenv\">\.doc
SF:kerenv</A>\n<LI><A\x20HREF=\"bin/\">bin/</A>\n<LI><A\x20HREF=\"boot/\">
SF:boot/</A>\n<LI><A\x20HREF=\"cdrom/\">cdrom/</A>\n<LI><A\x20HREF=\"core\
SF:">core</A>\n<LI><A\x20HREF=\"dev/\">dev/</A>\n<LI><A\x20HREF=\"etc/\">e
SF:tc/</A>\n<LI><A\x20HREF=\"home/\">home/</A>\n<LI><A\x20HREF=\"initrd/\"
SF:>initrd/</A>\n<LI><A\x20HREF=\"initrd\.img\">initrd\.img</A>\n<LI><A\x2
SF:0HREF=\"lib/\">lib/</A>\n<LI><A\x20HREF=\"lost%2Bfound/\">lost\+found/<
SF:/A>\n<LI><A\x20HREF=\"media/\">media/</A>\n<LI><A\x20HREF=\"mnt/\">mnt/
SF:</A>\n<LI><A\x20HREF=\"nohup\.out\">nohup\.out</A>\n<LI><A\x20HREF=\"op
SF:t/\">opt/</A>\n<LI><A\x20HREF=\"proc/\">proc/</A>\n<LI><A\x20HREF=\"roo
SF:t/\">root/</A>\n<LI><A\x20HREF=\"sbin/\">sbin/</A>\n<LI><A\x20HREF=\"sr
SF:v/\">srv/</A>\n<LI><A\x20HREF=\"sys/\">sys/</A>\n<LI><A\x20HREF=\"tmp/"
SF:)%r(HTTPOptions,109,"\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/
SF:#\x20OPTIONS\x20/\x20HTTP/1\.0\nbash:\x20OPTIONS:\x20command\x20not\x20
SF:found\n\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20\n\x1b\]0
SF:;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20\n\x1b\]0;@00d8b7edcf5a
SF::\x20/\x07root@00d8b7edcf5a:/#\x20\n\x1b\]0;@00d8b7edcf5a:\x20/\x07root
SF:@00d8b7edcf5a:/#\x20")%r(RTSPRequest,109,"\x1b\]0;@00d8b7edcf5a:\x20/\x
SF:07root@00d8b7edcf5a:/#\x20OPTIONS\x20/\x20RTSP/1\.0\nbash:\x20OPTIONS:\
SF:x20command\x20not\x20found\n\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7e
SF:dcf5a:/#\x20\n\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20\n
SF:\x1b\]0;@00d8b7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20\n\x1b\]0;@00d8b
SF:7edcf5a:\x20/\x07root@00d8b7edcf5a:/#\x20");
MAC Address: 02:42:AD:00:48:02 (Unknown)
Service Info: Hosts: localhost, irc.Metasploitable.LAN,  metasploitable.localdomain; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
```

The output we see here is the fingerprint mentioned in the assignment instructions and in nmap's documentation. This feels like playing Fallout hacking, spotting human-readable things that make sense. Those include:

- `root@00d8b7edcf5a:/#` - A Linux shell prompt on root user, hostname `00d8b7edcf5a`. Thus, it seems to be an unauthenticated shell access, which is a critical vulnerability.
- `.dockerenv` - This file is present in Docker containers, so this is a strong indication that the target is running in a Docker container.

Netcat or telnet was not installed, so I had to ask Gemini for tips on how I would connecto to this shell. Apparently, `curl` can handle telnet protocol, so I ran the following command:

```
$ curl telnet://173.0.72.2:46381
root@00d8b7edcf5a:/# ls
bin
boot
cdrom
core
dev
```

== Assignment Solution

The `16422/tcp` is the SSH port I have been looking for. Having an open port for SSH open is not necessarily a vulnerability. Actually, using a non-standard port could be seen as a security measure.

I tried logging into the server using my `jksouran:jksouran81169` credentials as well as typical `root:root` and `admin:admin` combinations, but none of those worked. I also tried `hydra` with:

```
hydra -L /usr/share/usernames \
-P /usr/share/common_3k.txt 173.0.72.2 \
http-post-form "/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed"
```

This scan did not yield any valid credentials. However, the OpenSSH version 4.7 is almost 20 years old, so it is likely to have vulnerabilities. Thus, I consider this a *CRITICAL* vulnerability. There is really no need to exploit the SSH port, if a direct access to root shell is already open. This, too, is a *CRITICAL* vulnerability.
