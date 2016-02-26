class{ 'maas':
  maas_maintainers_release => 'stable',
#  superuser { 'galera_admin':
#    password => 'maas',
#    email => 'ppouliot@microsoft.com',
#    require => Package[ 'maas' ],
}
