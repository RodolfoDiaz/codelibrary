# Linux Debian/Ubuntu basic configuration commands

## Check Linux Version

To [check Linux Version](https://linuxize.com/post/how-to-check-linux-version/) you can use:

Using lsb_release command:

    lsb_release -a

Using /etc/os-release file:

    cat /etc/os-release

Using uname command:

    uname -srm

## Create Users in Linux

To [Create Users in Linux (useradd Command)](https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/), for example to create a new user named username1 you would run:

    sudo useradd username1

Use the -m (--create-home) option to create the user home directory as /home/username1:

    sudo useradd -m username1

To be able to log in as the newly created user, you need to set the user password. To do that run the passwd command followed by the username:

    sudo passwd username1

## Allow AD Domain Users to login through console (SSH)

Enter the following commands:

1. Add the user (Domain\username) to the users.allow file.

    ```
    sudo nano /etc/opt/quest/vas/users.allow
    ```

2. To apply the changes, execute the following:

    ```
    sudo /opt/quest/bin/vastool flush
    ```

3. Validate the change:
    ```
    /opt/quest/bin/vastool user checkaccess <new_user>
    ```

**Note:** For Domain Users to be able to login through SSH, make sure the Active Directory user account has "UNIX Attributes" settings configured.

## Add User to Sudoers in Debian

To [add User to Sudoers in Debian](https://linuxize.com/post/how-to-add-user-to-sudoers-in-debian/) you can use the following command.

      usermod -aG sudo username1

Make sure you change “username1” with the name of the user that you want to grant access to.
An alternative way is to add the User to the sudoers File.

     sudo nano /etc/sudoers

Edit the file and add a new entry, for example: username1 ALL=(root)NOPASSWD:ALL

## apt Command in Linux

apt is a command-line utility for installing, updating, removing, and otherwise managing deb packages on Ubuntu, Debian, and related Linux distributions. It combines the most frequently used commands from the apt-get and apt-cache tools with different default values of some options.

    sudo apt update
    sudo apt upgrade

To install Nano text editor on Debian or Ubuntu machines, execute the following command:

    sudo apt install nano

For reference read [here](https://linuxize.com/post/how-to-use-apt-command/).

## Set DNS Nameservers

The /etc/resolv.conf is the main configuration file for the DNS name resolver library. The resolver is a set of functions in the C library that provide access to the Internet Domain Name System (DNS).  More reference [here](https://www.tecmint.com/set-permanent-dns-nameservers-in-ubuntu-debian/).

     $ sudo nano /etc/resolvconf/resolv.conf.d/head

If your network connection is direct to the Internet you can use public DNS servers:

    nameserver 8.8.4.4
    nameserver 8.8.8.8

Inside a corporate network you have to use the internal DNS servers (IP address), for example:

    nameserver 10.248.2.1
    nameserver 10.248.2.9

Save the changes and restart the resolvconf.service or reboot the system.

Now when you check the /etc/resolv.conf file, the name server entries should be stored there permanently. 

    $ sudo nano /etc/resolv.conf

## Configure Proxy settings

In order to access external services, you would normally need to setup a proxy.

    $ sudo tee /etc/apt/apt.conf > /dev/null << EOT

    Acquire::http::proxy "http://proxy.server.com:911";
    Acquire::https::proxy "https://proxy.server.com:912";
    EOT

    $ sudo tee /etc/environment > /dev/null << EOT

    HTTP_PROXY="http://proxy.server.com:911"
    http_proxy="http://proxy.server.com:911"
    HTTPS_PROXY="https://proxy.server.com:912"
    https_proxy="https://proxy.server.com:912"
    FTP_PROXY="http://proxy.server.com:911"
    ftp_proxy="http://proxy.server.com:911"
    ALL_PROXY="http://proxy.server.com:911"
    all_proxy="http://proxy.server.com:911"
    NO_PROXY="localhost,127.0.0.1"
    no_proxy="localhost,127.0.0.1"
    NO_PROXY="mycompany.com"
    no_proxy="mycompany.com"
    EOT

    $ source /etc/environment
    
    $ sudo git config --system http.proxy http://proxy.server.com:911
    $ sudo git config --system https.proxy https://proxy.server.com:912

In order for these settings to take effect, you might need to reboot (sudo reboot).

## Configure a new volume

Check what are the block storage devices that are attached:

    lsblk --all

for example, we see a disk named "xvdb".

mke2fs is used to create an ext2, ext3, or ext4 filesystem, usually in a disk partition

    sudo mke2fs /dev/xvdb

Mount the new volume in the Linux machine.  The parameters are: first the mount point and the folder the we want to mount that volume.

    sudo mount /dev/xvdb /mnt

Change to the folder defined, or create files/folders on the new volume.

    cd /mnt
    ls -la

To unmount the volume to the folder, do the following:

    umount /mnt

## Check Disk Space

Linux has a strong built-in utility called ‘df‘. The ‘df‘ command stands for “disk filesystem“, it is used to get a full summary of available and used disk space usage of the file system on Linux system.

Using ‘-h‘ parameter with (df -h) will show the file system disk space statistics in “human readable” format, means it gives the details in bytes, megabytes, and gigabyte.

    df -h

Display Information of all File System Disk Space Usage

    df -a

fdisk -l shows disk size along with disk partitioning information

    fdisk -l

## Check memory usage

The free command is the most simple and easy to use command to check memory usage on linux. 
Here is a quick example, showing output in human-readable format.

    free -h

The top command is generally used to check memory and cpu usage per process. However it also reports total memory usage and can be used to monitor the total RAM usage.

    top

## Other commands

- ps -l - to show all the running processes
- dmesg - to list all the kernel messages
- lsblk - to list all the block devices - here you will see your drives
