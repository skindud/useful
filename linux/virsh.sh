#virsh

#bridge
#https://www.tecmint.com/create-network-bridge-in-rhel-centos-8/
nmcli connection add type bridge autoconnect yes con-name br0 ifname br0
ifconfig 
nmcli connection modify br0 ipv4.addresses 192.168.8.11/24 ipv4.method manual
nmcli connection modify br0 ipv4.gateway 192.168.8.1
nmcli connection modify br0 ipv4.dns 192.168.8.1
nmcli connection modify br0 ipv4.dns-search kindud.ru
# nmcli connection del enp0s31f6
# nmcli connection add type bridge-slave autoconnect yes con-name enp0s31f6 
nmcli connection del enp0s31f6
nmcli connection add type bridge-slave autoconnect yes con-name enp0s31f6 
nmcli connection add type bridge-slave autoconnect yes con-name enp0s31f6 master br0




virt-install \
--name k31 \
--ram 4096 \
--disk path=/var/kvm/images/k31.img,size=20 \
--vcpus 2 \
--os-variant centos-stream9 \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--location /home/extra/kvm/isos/CentOS-8.3.2011-x86_64-dvd1.iso \
--extra-args 'console=ttyS0,115200n8'

virsh migrate --live --copy-storage-all k95 qemu+ssh://192.168.8.12/system 

virt-clone --original k31 --name k32 --auto-clone

virsh list --all|tail -n +3|awk '{print $2}'|xargs -n 1 echo virsh shutdown|sh


#without_sudo 
#https://localhosts.ru/question/61221-centos-virsh-razreshit-polzovatelyam-bez-sudo-vzaimodeystvovat-s-qemu-kvm-virtualnymi-mashinami
export LIBVIRT_DEFAULT_URI=qemu:///system

#kvm_install
#https://www.server-world.info/en/note?os=CentOS_Stream_9&p=kvm&f=2