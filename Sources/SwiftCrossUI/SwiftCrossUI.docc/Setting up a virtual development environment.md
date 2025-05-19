# Setting up a virtual development environment

Detailed set up instructions for virtual Linux and Windows development environments.

## Overview

Most developers only have access to one or two of the major operating systems for development. Setting up virtual machines is an important part of developing and testing cross-platform apps, especially for smaller less-specialized teams.

This article covers VM creation, leaving set up to the more general <doc:Setting-up-development-environments> article which applies to both physical and virtual machines.

So far this article only covers macOS hosts but will be expanded to cover other host OSes in future.

## Creating VMs on macOS hosts (UTM)

Before continuing, make sure that you've installed [UTM](https://mac.getutm.app/). A download link is available on their website.

These instructions have been adapted from [UTM's VM creation guides](https://docs.getutm.app/guides/guides/).

### Windows guests

These instructions apply to both Windows 10 and Windows 11. Choose which you want to install before you get started. We recommend Windows 11 because it's better supported by UTM, especially on Apple Silicon.

Here are links to the relevant ISO download pages:

- [Windows 11 x64 ISO](https://www.microsoft.com/en-us/software-download/windows11)
- [Windows 11 arm64 ISO](https://www.microsoft.com/en-us/software-download/windows11arm64)
- [Windows 10 x64 ISO](https://www.microsoft.com/en-au/software-download/windows10iso)
- Unfortunately Windows 10 arm64 doesn't support VM hypervisors. Microsoft also doesn't provide any downloads for it.

Once you've decided on a Windows version, you can begin the VM creation process.

1. Download the installer ISO for your chosen Windows version. Make sure it matches the architecture of your host machine (arm64 for Apple Silicon).
2. Click the `+` button in UTM.
3. Select `Virtualize`.
4. Select `Windows`.
5. Click `Browse...` and select the ISO you downloaded.
6. Ensure that `Install Windows 10 or higher` and `Install drivers and SPICE tools` are both checked. Click `Continue`.
7. Configure the amount of RAM and number of CPU cores to allocate. Then click `Next`.
   - Linking `swift-winui` and `swift-uwp` can be pretty RAM intensive. We recommend allocating as much RAM as you can without compromising your macOS experience.
8. Configure the amount of storage to allocate. Click `Next`.
9. Press `Save` to create the VM. Then press `Run` to start the VM.
10. Follow any instructions the Windows installer gives you.
11. Once the installation process has completed, navigate to the `D:` drive in file explorer and run the Spice Guest Tools installer. This enables clipboard sharing and automatic display resizing.

The next few steps are optional, and walk through setting up a shared directory between the host and guest machines.

1. Shutdown the VM.
2. Click the edit button (the icon with 3 sliders) in the top right of UTM and navigate to the `Sharing` tab.
3. Set `Path` to the directory you want to share (probably your top-level projects directory).
4. Ensure that `Directory Share Mode` is set to `SPICE WebDAV`.
5. Boot the VM.

You should now find the shared directory mounted as a drive inside your Windows VM.

You're now ready to begin setting up a SwiftCrossUI development environment inside your Windows VM. Head over to <doc:Setting-up-development-environments> to continue.

### Linux guests

You must choose a Linux distribution before starting VM creation. We recommend Ubuntu 24.04 because it has the best Swift support. Fedora is also great, but the latest version that Swift officially supports is a year and a half old.

Here's a list of ISO download pages for the most common Linux distribution choices:

- [Ubuntu Desktop 24.04 x64](https://ubuntu.com/download/desktop)
- [Ubuntu Server 24.04 arm64](https://ubuntu.com/download/server/arm); Ubuntu doesn't provide stable arm64 desktop iso downloads, but it only takes one extra step to convert to install the Ubuntu desktop environment
- [Ubuntu Desktop 24.04 arm64 (daily build)](https://cdimage.ubuntu.com/daily-live/20240421/); unstable, mileage may vary

Once you've decided on a Linux distribution, you can begin the VM creation process.

1. Download the install ISO for your chosen Linux distribution. Make sure it matches the architecture of your host machine (arm64 for Apple Silicon).
2. Click the `+` button in UTM.
3. Select `Virtualize`.
4. Select `Linux`.
5. Click `Browse...` and select the ISO you downloaded.
6. Click `Continue`.
7. Configure the amount of RAM and number of CPU cores to allocate. Then click `Next`.
8. Configure the amount of storage to allocate. Click `Continue`.
9. [Optional]: Select a directory to share with the VM. Do this if you want to use your preferred code editor on your host machine to edit code as you test it in the VM (recommended). You will have to perform some additional steps post-installation to configure directory sharing in the guest.
10. Click `Continue`.
11. Click `Save` to create the VM. Then press `Run` to start the VM.
12. Follow the Ubuntu installer.

You should now have a working VM. If you used an Ubuntu Server installer, run the following commands to install a graphical environment:

```sh
sudo apt update
sudo apt install ubuntu-desktop
sudo reboot
```

Run the following command to enable clipboard sharing and dynamic display resizing:

```sh
# Ubuntu, Debian, apt-based
sudo apt install spice-vdagent
# Fedora, CentOS, RPM-based
sudo yum install spice-vdagent
```

If you selected a directory to share with the VM, set up your VM to automatically mount the shared directory on boot. To do so, follow these steps, replacing `USER` with your VM username.

1. Edit `/etc/fstab` to add the following two lines:

```
share /mnt/utm 9p trans=virtio,version=9p2000.L,rw,_netdev,nofail,auto 0 0
/mnt/utm /home/USER/utm fuse.bindfs map=501/1000:@20/@1000,x-systemd.requires=/mnt/utm,_netdev,nofail,auto 0 0
```

2. Now run the following commands to install required dependencies, create your mount destinations, and reboot so that your changes take effect:

```sh
sudo apt install bindfs
sudo mkdir /mnt/utm
mkdir /home/USER/utm
sudo reboot -h now
```

3. You'll find your directory mounted at `~/utm`. If you run into file ownership related issues, check your macOS user id (with the `id -u` command). If it isn't `501`, update the `bindfs` fstab rule accordingly and reboot again.

You're now ready to begin setting up a SwiftCrossUI development environment inside your Linux VM. Head over to <doc:Setting-up-development-environments> to continue.

<!-- ## Creating VMs on Linux hosts (Gnome Boxes) -->

<!-- ### Windows guests -->

<!-- ### Linux guests -->

<!-- Linux virtual machines can be useful when you need to test on multiple Linux distributions. -->
