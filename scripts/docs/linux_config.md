# Linux Debian/Ubuntu Basic Configuration Commands

## Check Linux Version

To [check Linux Version](https://linuxize.com/post/how-to-check-linux-version/) you can use:

Using `lsb_release` command (requires the `lsb-release` package):

```bash
lsb_release -a
```

Using `/etc/os-release` file:

```bash
cat /etc/os-release
```

Using `uname` command:

```bash
uname -srm
```

## Create Users in Linux

To [Create Users in Linux (`useradd` Command)](https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/), for example to create a new user named `username1`, run:

```bash
sudo useradd username1
```

Use the `-m` (`--create-home`) option to create the user's home directory as `/home/username1`:

```bash
sudo useradd -m username1
```

To be able to log in as the newly created user, set the user password by running the `passwd` command followed by the username:

```bash
sudo passwd username1
```

## Allow AD Domain Users to Login Through Console (SSH)

If you are using Quest Authentication Services (Vastool), enter the following commands:

1. Add the user (`Domain\username`) to the `users.allow` file:

```bash
sudo nano /etc/opt/quest/vas/users.allow
```

2. Apply the changes:

```bash
sudo /opt/quest/bin/vastool flush
```

3. Validate the change:

```bash
/opt/quest/bin/vastool user checkaccess <new_user>
```

**Note:** For Domain Users to be able to log in through SSH, make sure the Active Directory user account has "UNIX Attributes" settings configured.

## Add User to Sudoers in Debian

To [add a User to Sudoers in Debian](https://linuxize.com/post/how-to-add-user-to-sudoers-in-debian/), use the following command:

```bash
sudo usermod -aG sudo username1
```

Make sure you replace `username1` with the name of the user you want to grant access to.

An alternative way is to safely edit the sudoers file using `visudo`:

```bash
sudo visudo
```

Add a new entry, for example:

```text
username1 ALL=(root) NOPASSWD:ALL
```

## APT Package Management

### `apt-get` Command

Debian—the base distribution for Ubuntu, Linux Mint, elementary OS, and others—uses the `dpkg` packaging system and the Advanced Packaging Tool (APT) suite to manage software packages. Historically, common package management commands were split across low-level utilities like `apt-get` and `apt-cache`.

### `apt` Command

The `apt` command was introduced to streamline common workflows by combining the most frequently used features from `apt-get` and `apt-cache` into a single, more user-friendly command-line utility.

```bash
sudo apt update
sudo apt upgrade
```

For example, to install the Nano text editor on Debian or Ubuntu machines, execute:

```bash
sudo apt install nano
```

For reference, read [how to use the apt command](https://linuxize.com/post/how-to-use-apt-command/).

### Difference Between `apt` and `apt-get` Commands

| `apt` command      | Replaces command       | Function                                             |
| :----------------- | :--------------------- | :--------------------------------------------------- |
| `apt install`      | `apt-get install`      | Installs a package                                   |
| `apt remove`       | `apt-get remove`       | Removes a package                                    |
| `apt purge`        | `apt-get purge`        | Removes a package along with its configuration files |
| `apt update`       | `apt-get update`       | Refreshes the repository package index               |
| `apt upgrade`      | `apt-get upgrade`      | Upgrades all upgradable packages                     |
| `apt autoremove`   | `apt-get autoremove`   | Removes unused dependency packages                   |
| `apt full-upgrade` | `apt-get dist-upgrade` | Upgrades packages with automatic dependency handling |
| `apt search`       | `apt-cache search`     | Searches repositories for a program                  |
| `apt show`         | `apt-cache show`       | Displays detailed package information                |

`apt` also includes a few unique commands of its own:

| New `apt` command  | Function                                                       |
| :----------------- | :------------------------------------------------------------- |
| `apt list`         | Lists packages based on criteria (installed, upgradable, etc.) |
| `apt edit-sources` | Opens the sources list file for editing                        |

### What is the Difference Between `apt remove` and `apt purge`?

- **`apt remove`** removes the binaries of a package while leaving residual configuration files intact. If you reinstall the package later, your previous settings will remain.
- **`apt purge`** completely removes everything related to a package, including its system configuration files. This is useful when you want to reset a broken configuration and start fresh (and can also be run on an already-removed package).

---

## Network Settings

You can check active network interfaces and configured IP addresses using:

```bash
ip addr
```

_(Note: Modern Debian and Ubuntu systems use Predictable Network Interface Names such as `ens33`, `enp0s3`, or `eno1` instead of `eth0`.)_

## Set DNS Nameservers

The `/etc/resolv.conf` file is the configuration file for the DNS name resolver library. For systems utilizing the `resolvconf` utility, you can set permanent nameservers by editing the head file ([more reference](https://www.tecmint.com/set-permanent-dns-nameservers-in-ubuntu-debian/)):

```bash
sudo nano /etc/resolvconf/resolv.conf.d/head
```

_(Note: On modern Ubuntu/Debian installations using `systemd-resolved` or Netplan, DNS settings are typically managed through `/etc/netplan/_.yaml`or`nmcli`rather than editing`/etc/resolv.conf` directly.)\*

If your network connection is direct to the Internet, you can use public DNS servers:

```text
nameserver 8.8.4.4
nameserver 8.8.8.8
```

Inside a corporate network, use your internal DNS server IP addresses, for example:

```text
nameserver 10.248.2.1
nameserver 10.248.2.9
```

Save the changes and restart the service (`sudo systemctl restart resolvconf.service`) or reboot the system. You can verify the active DNS configuration with:

```bash
cat /etc/resolv.conf
```

## Configure Proxy Settings

In order to access external services behind a corporate firewall, configure your proxy settings across APT, environment variables, and Git:

1. **Configure APT proxy:**

```bash
sudo tee /etc/apt/apt.conf > /dev/null << EOT
Acquire::http::proxy "http://proxy.server.com:911";
Acquire::https::proxy "https://proxy.server.com:912";
EOT
```

2. **Configure system-wide environment variables (`/etc/environment`):**

```bash
sudo tee /etc/environment > /dev/null << EOT
HTTP_PROXY="http://proxy.server.com:911"
http_proxy="http://proxy.server.com:911"
HTTPS_PROXY="https://proxy.server.com:912"
https_proxy="https://proxy.server.com:912"
FTP_PROXY="http://proxy.server.com:911"
ftp_proxy="http://proxy.server.com:911"
ALL_PROXY="http://proxy.server.com:911"
all_proxy="http://proxy.server.com:911"
NO_PROXY="localhost,127.0.0.1,mycompany.com"
no_proxy="localhost,127.0.0.1,mycompany.com"
EOT
```

3. **Reload the environment file:**

```bash
source /etc/environment
```

4. **Configure Git proxy (optional):**

```bash
sudo git config --system http.proxy http://proxy.server.com:911
sudo git config --system https.proxy https://proxy.server.com:912
```

In order for all system services to pick up the new environment variables, you may need to reboot (`sudo reboot`).

## Configure a New Volume

Check attached block storage devices:

```bash
lsblk --all
```

For example, if you see an unformatted disk named `xvdb`, create an `ext4` filesystem on it:

```bash
sudo mkfs.ext4 /dev/xvdb
```

Mount the new volume to a target directory (e.g., `/mnt`):

```bash
sudo mount /dev/xvdb /mnt
```

Navigate to the mount point to verify or create files:

```bash
cd /mnt
ls -la
```

To unmount the volume when finished:

```bash
sudo umount /mnt
```

## Check Disk Space

The `df` (disk filesystem) utility provides a summary of available and used disk space. Adding the `-h` flag displays sizes in human-readable format (KB, MB, GB):

```bash
df -h
```

Display information for all filesystems (including pseudo and duplicate filesystems):

```bash
df -a
```

View disk sizes alongside partition tables using `fdisk`:

```bash
sudo fdisk -l
```

## Check Memory Usage

Use the `free` command with `-h` to display total, used, and available RAM and swap memory in human-readable format:

```bash
free -h
```

Use `top` to monitor real-time CPU and memory usage per process as well as total system resource consumption:

```bash
top
```

## Other Useful Commands

- `ps aux` — Display all running processes across the system.
- `dmesg` — Print kernel ring buffer and hardware/boot messages.
- `lsblk` — List information about all available block storage devices.
