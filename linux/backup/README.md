# backup

## disclaimer

<!--
WARNING!!!
Use the following command carefully with fully understanding. Otherwise you disks might be broken.
-->

## backup disk to file
size_of_disk=$(lsblk -lab|grep "^nvme0n1 "|awk '{print $4}')
time sudo dd if=/dev/nvme0n1 bs=4M conv=sync,noerror | pv -s ${size_of_disk} -cN 1_disk| gzip -c|pv -cN 2_gzip|tee > tmp.img.gz

## restore backup to disk
size_of_image=$(du -sb image.iso | awk '{print $1}')
time cat tmp1.img.gz | pv -s ${size_of_image} -cN 1_image_gzipped|zcat|pv -cN 2_image_raw|sudo dd of=/dev/nvme0n1 conv=fdatasync
