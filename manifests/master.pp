notify { "Provisioning master on ${hostname} node.": }

package { 'ambari-server' : 
  ensure => 'installed',
  allow_virtual => false,
}

# ugly
#file {[
#  '/var/lib/ambari-server/resources/stacks/HDPLocal', 
#  '/var/lib/ambari-server/resources/stacks/HDPLocal/2.4',
#  '/var/lib/ambari-server/resources/stacks/HDPLocal/2.4/repos']: 
#    ensure => 'directory',
#}
  
#file { '/var/lib/ambari-server/resources/stacks/HDP/2.4/repos/repoinfo.xml':
#  ensure  => file,
#  content => template('repoinfo.xml'),
#  require => Package['ambari-server']
#}



exec { 'ambari-server-setup':
  command => '/usr/sbin/ambari-server setup --debug --verbose --silent --java-home /usr/jdk64/jdk1.8.0_60',
  logoutput => true,
  require => Package['ambari-server']
}

service { 'ambari-server':
  ensure 		=> running,
  enable 		=> true,
  require => [
    Package['ambari-server'],
    Exec['ambari-server-setup']
  ]
}

exec {'wait-for-ambari-server':  
  command => "/usr/bin/wget --spider --tries 10 --retry-connrefused --no-check-certificate http://c6601.ambari.apache.org:8080",
  require => Service["ambari-server"],
}

exec {'local_hdp':
  command => '/usr/bin/curl -H "X-Requested-By: ambari" -X POST -u admin:admin -X PUT -d @/tmp/vagrant-puppet/blueprints/hdp_repo.json http://c6601.ambari.apache.org:8080/api/v1/stacks/HDP/versions/2.4/operating_systems/redhat6/repositories/HDP-2.4', 
  logoutput => true,
  require => Exec['wait-for-ambari-server']
}

exec {'local_hdp_utils':
  command => '/usr/bin/curl -H "X-Requested-By: ambari" -X POST -u admin:admin -X PUT -d @/tmp/vagrant-puppet/blueprints/hdp_utils_repo.json http://c6601.ambari.apache.org:8080/api/v1/stacks/HDP/versions/2.4/operating_systems/redhat6/repositories/HDP-UTILS-1.1.0.20', 
  logoutput => true,
  require => Exec['wait-for-ambari-server']
}

#http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.4.3.0/HDP-2.4.3.0-centos6-rpm.tar.gz
yumrepo { 'HDP':
  baseurl => "http://localhost/HDP/centos6/2.x/updates/2.4.0.0",
  descr => "HDP",
  enabled => 1,
  gpgcheck => 0,
  require => Exec['local_hdp']
}

yumrepo { 'HDP-UTILS':
  baseurl => "http://localhost/HDP-UTILS-1.1.0.20/repos/centos6",
  descr => "HDP-UTILS",
  enabled => 1,
  gpgcheck => 0,
  require => Exec['local_hdp_utils']
}

exec {'blueprint':
  command => '/usr/bin/curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://c6601.ambari.apache.org:8080/api/v1/blueprints/blueprint -d @/tmp/vagrant-puppet/blueprints/blueprint-singlenode.json', 
  logoutput => true,
  require => [              
    Yumrepo['HDP'],
    Yumrepo['HDP-UTILS']]
}

exec {'cluster':
  command => '/usr/bin/curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://c6601.ambari.apache.org:8080/api/v1/clusters/cluster -d @/tmp/vagrant-puppet/blueprints/cluster-singlenode.json', 
  logoutput => true,
  require => Exec['blueprint']
}