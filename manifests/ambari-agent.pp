notify { "Provisioning default on ${hostname} node.": }

# /etc/hosts
#host { 'c7201':   ip => '192.168.72.101',  host_aliases => [ 'c7201.barenode.org', 'c7201']}
#host { 'c7202':   ip => '192.168.72.102',  host_aliases => [ 'c7202.barenode.org', 'c7202']}
#host { 'c7203':   ip => '192.168.72.103',  host_aliases => [ 'c7203.barenode.org', 'c7203']}
#host { 'c7204':   ip => '192.168.72.104',  host_aliases => [ 'c7204.barenode.org', 'c7204']}

file { '/etc/hosts':
  ensure  => file,
  content => template('common/hosts')
}

#Java SDK
# ugly
file {[
  '/usr/jdk64']: 
  ensure => 'directory',
}

file {"/usr/jdk64/jdk-8u60-linux-x64.tar.gz":
  ensure  => present,
  source  => "/var/www/html/ARTIFACTS/jdk-8u60-linux-x64.tar.gz",
  owner   => "vagrant",
}

exec { "unzip_sdk":
  command     => "/bin/gunzip /usr/jdk64/jdk-8u60-linux-x64.tar.gz",
  cwd         => "/usr/jdk64",
  logoutput => true,
  require      => File["/usr/jdk64/jdk-8u60-linux-x64.tar.gz"]
}

exec { "untar_sdk":
  command     => "/bin/tar xf /usr/jdk64/jdk-8u60-linux-x64.tar",
  cwd         => "/usr/jdk64",
  logoutput => true,
  require      => Exec["unzip_sdk"]
}

service { 'firewalld':
  ensure => 'stopped',
  enable => 'false'
}

package { 'ntp' : 
  ensure => 'installed',
  allow_virtual => false,
}

service { 'ntpd':
  ensure 		=> running,
  enable 		=> true,
  require => Package['ntp']
}

#local YUM repo
package { 'httpd' : 
  ensure => 'installed',
  allow_virtual => false
}

service { 'httpd':
  ensure 		=> running,
  enable 		=> true,
  require => Package['httpd']
}

yumrepo { 'ambari':
  baseurl => "http://localhost/ambari/centos7/2.x/updates/2.4.2.0",
  descr => "AMBARI",
  enabled => 1,
  gpgcheck => 0,
  require => Service['httpd']
}

#ambari agent
package { 'ambari-agent' : 
  ensure => 'installed',
  allow_virtual => false,
  require => Yumrepo['ambari']
}

file { '/etc/ambari-agent/conf/ambari-agent.ini':
  ensure  => file,
  content => template('common/ambari-agent.ini'),
  require => Package['ambari-agent']
}

service { 'ambari-agent':
  ensure 		=> running,
  enable 		=> true,
  require => File['/etc/ambari-agent/conf/ambari-agent.ini']  
}





