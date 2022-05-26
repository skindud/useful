# Other

## LVM reduce/extend

lsblk
sudo growpart /dev/xvda 1
sudo resize2fs /dev/xvda1
df -h
lsblk
sudo pvdisplay
sudo pvresize /dev/nvme1n1
sudo pvdisplay
sudo lvextend -r -l +100%FREE /dev/vg1/lv1
df -h
umount /vg1/lv1 # if need to reduce only
time e2fsck -f /dev/vg1/lv1
time lvreduce -r -L 20G /dev/vg1/lv1 # 20G - size must be less than a new disk
mount /vg1/lv1 # if need to reduce only
pvcreate /dev/nvme1n1 # new disk
vgextend vg1 /dev/nvme1n1
time pvmove /dev/nvme0n1 /dev/nvme1n1
vgreduce vg1 /dev/nvme0n1
pvremove /dev/nvme0n1
lvextend -r -l +100%FREE /dev/vg1/lv1
pvresize /dev/vda2

- <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-modify-volume.html?icmpid=docs_ec2_console>

## Unsorted

sudo yum install bash-completion bash-completion-extras

