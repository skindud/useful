# backup

# WARNING!!!
# Use the following command carefully with fully understanding. Otherwise you disks might be broken.

# backup disk to file
size_of_disk=$(lsblk -lab|grep 'sda '|awk '{print $4}')
sudo dd if=/dev/sda bs=4M conv=sync,noerror| pv -s ${size_of_disk} | gzip -c > backup.img.gz

# restore backup to disk
size_of_image=$(du -sb image.iso | awk '{print $1}')
sudo dd if=backup.img.gz | pv -s ${size_of_image} | sudo of=/dev/sda conv=fdatasync

# write iso to USB flash
size_of_image=$(du -sb image.iso | awk '{print $1}')
sudo dd if=image.iso | pv -s ${size_of_image} | sudo of=/dev/sda conv=fdatasync
