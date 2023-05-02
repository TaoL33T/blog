---
layout: post
title: How to change the root file system on arch linux.
date: 2020-07-26 13:17:19 +0200
description: How I changed the root file system of my Arch Linux machine from ext4 to F2FS the dirty way.
---


So basically, I read about the surperiority of F2FS, the flash friendly file system, on [phoronix.com](https://www.phoronix.com/scan.php?page=article&item=linux-58-filesystems&num=1).
At the moment I was using ext4 because I was annoyed by the file system checks that would occur after every kernel update.
But as mentionied [in the post](https://www.phoronix.com/scan.php?page=article&item=linux-58-filesystems&num=1), 
those checks could be a thing of the past in a few months because apparently others got annoyed by it aswell.

People who are more technically skilled than I am sat down and reworked the part that initiates the check upon startup,
so that it would only check the whole disk when it is absolutely neccessairy.
So far so good.
This is the piece of information that would lead me into the journey of switching my Laptop back to F2FS (again).

## So how did I do it?

After a bit of cleanup and removal of large files, the steps were as follows:

1. Boot the arch live-install media.
It is the best environment for these kind of tasks.

2. Mount my remote Backup folder via NFS and mount the rootfs.

3. Cd to the mounted rootfs and `tar -cvf /location/of/backup.tar ./`

4. Unmount the rootfs.

5. Destroy the current file-system: 

```
wipefs --all /dev/nvmexxxx
```

6. Create the F2FS file-system:

```
mkfs.f2fs /dev/nvmexxxx
```

7. Mount rootfs again and change directory to the mount point. 
This time also mount the EFI-System-Partition on `/efi` inside the rootfs.

8. Unpack the backed up file-system again with `tar -xvf /location/of/backup.tar`

9. Change root to the unpacked rootfs with `arch-chroot /mnt/rootfs`

10. Recreate the initcpio and grub-config so the system becomes bootable again.
The UUID of the root file system has changed after all.

```
mkinitcpio -p linux
grub-mkconfig -o /boot/grub/grub.cfg
```

This is the point where I realized that I forgot to install the `f2fs-tools`-package because `mkinitcpio` was complaining about missing file-system-tools.
So I quickly installed that with `pacman -Syyu f2fs-tools` and rerun the `mkinitcpio`-command.

11. If you were using grub the system would now be 100% bootable and you could go on, but even though I installed grub just for safety, I don't use it.

*(EDIT)*
*Actually, your system wouldn't be bootable at all because I was stupid.
You'd have to also change the UUID of the new partition in your `/etc/fstab`.
I actually honestly forgot to do that for about 3 months until I noticed that systemd was complaining about not being able to remount the root filesystem for some unknown reason, haha.*
*(alright, let's go on:)*

Instead, I use [a unified kernel image](https://wiki.archlinux.org/index.php/Systemd-boot#Preparing_a_unified_kernel_image) where the inital ramdisk and kernel are contained in one bootable EFI-file
that is then booted by the UEFI-firmware.

Basically, because I store my kernel command line in a text file, I had to edit that text file and change the UUID of the root file system to match the new file system.
My first attempt failed because I made a typo but after correcting that it would just boot up and it looked like nothing has changed at all.

*(EDIT)
Obviously, I didn't notice that I forgot to change the UUID in `/etc/fstab` because the correct UUID was givin via kernel command line and everything seemed to work
This might have also been the cause for my GRUB not working unnoticed but I didn't actually test if this solved the problem of GRUB complaining about a missing filesystem. (duh)*

<!-- end of list -->

## Success!

What did I gain from it?
Well probably not much, but it was a fun adventure anyways and I didn't have anything else to do during my DnD-session yesterday.
And it might be a nice tutorial for people who wanna change their root-file-system to something else regardless of the file-system.
Cheers.
