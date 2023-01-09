# hdd_crypt

## References
- https://unix.stackexchange.com/questions/710367/how-to-encrypt-an-existing-disk-on-fedora-without-formatting
- https://superuser.com/questions/117136/how-can-i-mount-a-partition-from-dd-created-image-of-a-block-device-e-g-hdd-u

This assumes a default Fedora installation, with the following Btrfs-based partitions:

    Root partition (Btrfs subvolumes "root" [mounted at /] and "home" [mounted at /home])
    Boot partition (mounted at /boot)
    EFI partition (UEFI systems only, mounted at /boot/efi)

Requirements

    A full-disk backup
    cryptsetup (should be included, otherwise install with dnf install cryptsetup)
    At least 100 MiB of free space
    A rescue system that can unmount the root filesystem (ex. Fedora live USB)
    NOTE: The encryption screen will use the keyboard layout defined in /etc/vconsole.conf (set with localectl). The layout cannot be changed at boot time.

Instructions

1. Identify the root filesystem with lsblk -f. Store the UUID (format XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX) for later use.
2. Identify your current kernel version with uname -r, and save this value for later.
3. Reboot into the rescue system. Locate the root filesystem with blkid --uuid <UUID>, and run a check on the filesystem with btrfs check <device>
4. Mount the filesystem with mount /dev/<device> /mnt
5. Shrink the filesystem to make room for the LUKS header. At least 32 MiB is recommended, use btrfs filesystem resize -32M /mnt
6. Unmount the filesystem: umount /mnt
7. Encrypt the partition with cryptsetup reencrypt --encrypt --reduce-device-size 32M /dev/<device>, providing a passphrase when prompted.
8. Identify the encrypted LUKS partition with lsblk -f (note that the UUID has changed). Save this LUKS partition UUID for later use.
9. Open the partition, providing your passphrase when prompted: cryptsetup open /dev/<device> system
10. Mount the mapped filesystem with mount /dev/mapper/system /mnt
11. Resize the filesystem to use all the space: btrfs filesystem resize max /mnt, then unmount the filesystem with umount /mnt
12. Mount the root subvolume (the Linux filesystem root) with mount -t btrfs -o "noatime,subvol=root,compress=zstd:1" /dev/mapper/system /mnt
13. Identify the devices for the boot and EFI partitions with lsblk. Mount the boot filesystem (mount /dev/<boot device> /mnt/boot), followed by the EFI filesystem for UEFI systems (mount /dev/<EFI device> /mnt/boot/efi).
14. Bind-mount the pseudo filesystems /dev, /dev/pts, /proc, /run, and /sys, in the format of mount --bind /sys /mnt/sys
15. Open a shell within the filesystem: chroot /mnt /bin/bash
16. Open /etc/default/grub with a text editor, and modify the kernel parameters to identify the LUKS partition, and temporarily disable SELinux enforcing. Add these parameters, then save the changes and close the file:

GRUB_CMDLINE_LINUX="[other params] rd.luks.uuid=<LUKS partition UUID> enforcing=0"

17. Configure a relabelling of SELinux with touch /.autorelabel
18. Regenerate the GRUB config: grub2-mkconfig -o /boot/grub2/grub.cfg (also generate for /etc/grub2.cfg, and on UEFI systems /etc/grub2-efi.cfg)
19. Regenerate initramfs to ensure cryptsetup is enabled: dracut --kver <kernel version>
Exit the chroot
20. Unmount all filesystems in reverse order. (For filesystems mounted with --bind, the option -l can be used.) Close the LUKS partition with cryptsetup close system
21. Reboot and log into the regular system. You'll be asked for your passphrase to decrypt the system during boot.
Open /etc/default/grub in a text editor, and reenable SELinux enforcing by removing enforcing=0 from GRUB_CMDLINE_LINUX. Save and exit.
Relabel SELinux again with touch /.autorelabel.
Repeat step 18 to regenerate the GRUB config.
Reboot and log into the system.

This answer heavily derives from maxschelpzig's answer and the Arch wiki. It also pulls from ceremcem's answer.



# history
blkid --uuid
blkid --uuid a6a68455-6296-48d0-bc1c-4f5751442815
btrfs check /dev/nvme0n1p3
mount /dev/<device> /mnt
mount /dev/nvme0n1p3 /mnt
ls /mnt
btrfs filesystem resize -32M /mnt
umount /mnt
ls /mnt
time cryptsetup reencrypt --encrypt --reduce-device-size 32M /dev/nvme0n1p3
lsblk -f
blkid --uuid f53f44e1-49ce-4648-872b-e574d5f00f70
cryptsetup open /dev/nvme0n1p3 system
mount /dev/mapper/system /mnt
ls /mnt
btrfs filesystem resize max /mnt
umount /mnt
ls /mnt
mount -t btrfs -o "noatime,subvol=root,compress=zstd:1" /dev/mapper/system /mnt
ls /mnt
mount /dev/nvme0n1p2 /mnt/boot
ls /mnt/boot/
mount --bind /dev /mnt/dev
mount --bind /dev/pts /mnt/dev/pts
mount --bind /proc /mnt/proc
mount --bind /run /mnt/run
mount --bind /sys /mnt/sys
chroot /mnt /bin/bash
ls /mnt/boot/
ls /mnt/
umount -l /mnt/{sys,run,proc,dev/pts,dev}
umount /mnt/boot 
umount /mnt
ls /mnt/
cryptsetup close system
history
