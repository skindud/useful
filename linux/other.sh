
#k8s

NS=<NSNAME>; for release in `helm list -n $NS -q`; do helm uninstall -n $NS $release; done; kubectl delete namespace $NS

kubectl get namespaces -o jsonpath="{range .items[*]}{.metadata.annotations.dbp\.inno\.tech\/owner}{'\t'}{.metadata.name}{'\n'}{end}" | grep -E '(review-|testing-)' | sort


#pv
tar c /etc/sudoers.d/igres|pv -s $(du -sb /etc/sudoers.d/igres|awk '{print $1}')|ssh 192.168.8.31 "cd /; tee|tar x"


#ansible preinstall 
time ssh <node_ip> "sudo yum -y install python39"

ansible all --inventory inventory/sample/hosts.ini --module-name ping


#kubespray
#libselinux-python
#https://github.com/kubernetes-sigs/kubespray/issues/5046

#kubespray
#No package matching 'python-httplib2' found available, installed or updated 
#https://github.com/kubernetes-sigs/kubespray/issues/1032?ysclid=l5hva88ezv761199484