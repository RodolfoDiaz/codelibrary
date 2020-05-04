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