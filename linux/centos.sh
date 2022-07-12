# disk clean
t_file="/root/tmp/`date +%Y%m%d.%H%M%S`.du.tmp"; echo $t_file
sudo bash -c "time du --max-depth=4 -h / > $t_file"
sudo bash -c "cat $t_file | sort -rh |head -20|nl"

# https://techglimpse.com/failed-metadata-repo-appstream-centos-8/
cd /etc/yum.repos.d/
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

