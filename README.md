# KYBS2001-penetration-testing

To build the PDF, type:

```bash
# To launch a live-updating PDF
typst watch report/main.typ

# To build a static PDF once
typst build report/main.typ
```

## LAB setup for Kali

**Why was this LAB created?** This is a two-fold motivation. First, Chydeniu's CinetCampus video platform was down and I did not have access to TIM KYBS2001, so I couldn't progress anything -- and I had reserved 12 hrs Saturday for studying. Thus, I had to find something to do. The Announcements section in Moodle contains Extra Activity being a mini.lab for AI-pentesting, so... here it goes.

I followed [The Complete Ethical Hacking Course](https://learning.oreilly.com/course/the-complete-ethical/9781839210495/) to complement the official course materials (the book list). I have an O'Reilly subscription, so I have access to a thousands of books and courses, including this one. I like this hands-on approach to learning, and the course is well-structured and comprehensive. Below is the lab setup I used for the exercises:

1. Intall virt-manager (on Ubuntu 26.04)
2. Go to `Edit > Connection Details > Virtual Networks` and identify the NAT we will be using, e.g.
    1. Name: default
    2. Network: `192.168.122.0/24`
    3. Forwarding: NAT
    4. DHCP Range: `192.168.122.2 - 192.168.122.254`.
3. Download the pre-built Kali for QEMU. Version `kali-linux-2026.1-qemu-amd64.7z` was the latest. Then extract the image and import it into virt-manager.

```bash
cd Downloads
7z x kali-linux-2026.1-qemu-amd64.7z
sudo mv kali-linux-2026.1-qemu-amd64/kali-linux-*.qcow2 /var/lib/libvirt/images/kali-2026-1.qcow2
```

Now, you can:

1. Click the Create a new virtual machine button in virt-manager.
2. Choose "Import existing disk image"
3. Select the `kali-2026-1.qcow2` image.
4. Fill the "Choose the operating system you are installing" form with: `Generic Linux 2024`.
5. Allocate at least 2GB of RAM and 2 CPU cores.
6. The machine should automatically connect to the default NAT network. Double check.
7. Finish the setup and start the VM. Login with `kali:kali`.
8. Open terminal and write `setxkbmap fi`. To avoid doing this every time, append it to zshrc: `echo "setxkbmap fi" >> ~/.zshrc`.

Wayland will ask you to Deny or Allow "Allow inhibitingh shortcuts". Allow it.

## Installing Windows

<details>
<summary>Windows Memo</summary>
 

Let's also install a Windows VM. For this, we need to emulate TPM 2.0 chip. This package does it:

```bash
sudo apt install swtpm
```

Now, we can download the ISO from [Microsoft > Download Windows 11](https://www.microsoft.com/en-us/software-download/windows11) and create a new VM in virt-manager, this time selecting "Local install media (ISO image or CDROM)". After downloading, let's move the image to `/var/lib/libvirt/images` and select it from the virt-manager UI.

```bash
sudo mv ~/Downloads/Win11_25H2_English_x64_v2.iso /var/lib/libvirt/images/windows-25h2.iso
```

Now, use this:

1. Click the Create a new virtual machine button in virt-manager.
2. Choose "Local install media (ISO image or CDROM)"
3. Select the `windows-25h2.iso` image. It will automatically detect the OS as "Windows 11".
4. Allocate at least 4GB of RAM and 4 CPU cores. 8 GB is recommended.
5. Make sure it is in the default NAT network.
6. Tick the "Customize configuration before install" option and click Finish.

The last checkbox will cause a new window to open. Here, we need to add the TPM 2.0 chip:

1. Click "Add Hardware" at the bottom left.
2. Choose "TPM".
3. Select (Advanced options) "TIS", Version 2.0, and Type "Emulated".
4. Click "Finish" to add the TPM.
5. Delete the default TPM that already existed.
6. Click "Begin Installation". Top left corner.

After clicking Next a couple of times, it will ask for a product key. The `OOBE\BYPASSNRO` no longer works. The [Microsoft Tech Community](https://techcommunity.microsoft.com/discussions/windows11/why-oobebypassnro-not-working-for-windows-11-25h2/4465864) provided answer that I am using. When language has been chosen...

* Press `Ctrl + Shift + F3` to enter the Audit Mode.
* The system will reboot and enter the built-in Administrator account.
* Press Windows Button, search and launch Computer Management
* Navigate -> Local Users and Groups.
* Right click -> New User. Create a new user with login `victim:password`. Make password to never expire.
* Double click the newly created user. Choose tab "Member Of" -> Add -> Advanced -> Find Now. Select "Administrators" and click OK.
* Close Computer Management
* There should be a window "System Preparation Tool 3.14". Click "Quit" and "Restart".
    * System cleanup action: OOBE
    * Shutdown option: Restart

Now the computer will reboot. It will ask you to accept EULA and SKIP choosing the computer name. The computer will once again reboot. This time, when asking for Sign In, press the `SHIFT + F10` to open the command prompt. Now run the `OOBE\BYPASSNRO` command. This will bypass the network requirement and allow you to create a local account. Create a local account with username `victim` and password `password`. You can skip the rest of the setup and go to the desktop.

~~This did not work. I never got to the desktop. I will simply do the same as I do every day: imagine Windows don't exist.~~

Actually, I still did try one thing. I chose "Office" instead of "Home". 

* This allows to click the `Sign-in options`.
* Choose: `Domain join instead`
* Enter your name: `anothervictim`
* Enter password: `password`

This actually worked! Then, I:

* Pressed Windows and looked for Windows Update: `Pause for 5 weeks`.
* Pressed Windows and looked for "Windows Security" -> "Virus & Threat Protection" -> "Manage Settings" -> "Real-time protection" -> Off.
* Windows Security -> Firewall & network protection -> Domain AND Private network -> Microsoft Defender Firewall -> Off.
  

Then I shut down the machine and took a snapshot.
</details>

## Installing Metasploitable 2

Download from [Sourceforge](https://sourceforge.net/projects/metasploitable/). Then...

```bash
# Unzip
cd Downloads
unzip metasploitable-linux-2.0.0.zip
cd Metasploitable2-Linux/

# Convert from VMDK to QCOW2
qemu-img convert -f vmdk -O qcow2 Metasploitable.vmdk metasploitable2.qcow2

# Move to images directory
sudo mv metasploitable2.qcow2 /var/lib/libvirt/images/
```

When creating the VM from the image, it is important to choose "Generic or unknown OS. Usage is not recommended" as the OS type. This will use the IDE instead of VirtIO. Otherwise, the machine hanged to...

> Starting up ...
>
> Loading, please wait...

There is no need to login, but if you want to, you can use the credentials `msfadmin:msfadmin`. The machine will automatically get an IP address from the DHCP server, so you can check it from virt-manager or by running `ip a` in the terminal (or `netdiscover -i eth0 -r 192.168.122.0/24 -c 10` to find it from Kali).'

**Memo:** run this `nmap -v -sS -A -T4 -oA <output_file> <ip>`. It is from 07:33 in video course, lesson titled First Scan, but with file output added by me. Outputs All formats (nmap, gnmap, xml).

## Usage of AI

I used AI only for reformatting purposes. All other work is mine. The most AI-intensive part was the conversion from LaTeX to Typst. Model used was Github Copilot Pro's GPT-5.4. I prefer Typst over LaTeX, and converting the report template manually would have served no purpose (in this course's context). I also used Copilot to e.g. create various scaffolding and template structures, like empty report sections, directory structures, Justfile placeholders, etc.
