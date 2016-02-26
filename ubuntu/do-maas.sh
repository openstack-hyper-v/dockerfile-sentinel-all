git clone https://github.com/ppouliot/puppet-maas /etc/puppet/modules/maas
sed "2d" -i /etc/puppet/modules/maas/manifests/init.pp
puppet apply --debug --trace --verbose --modulepath=/etc/puppet/modules /etc/puppet/manifests 
