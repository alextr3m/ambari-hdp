notify { "Provisioning default on ${hostname} node.": }

# /etc/hosts
host { 'c6601':   ip => '192.168.66.101',  host_aliases => [ 'c6601.barenode.org', 'c6601']}
host { 'c6602':   ip => '192.168.66.102',  host_aliases => [ 'c6602.barenode.org', 'c6602']}
host { 'c6603':   ip => '192.168.66.103',  host_aliases => [ 'c6603.barenode.org', 'c6603']}
host { 'c6604':   ip => '192.168.66.104',  host_aliases => [ 'c6604.barenode.org', 'c6604']}

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

service { 'iptables':
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
  allow_virtual => false,
}

service { 'httpd':
  ensure 		=> running,
  enable 		=> true,
  require => Package['httpd']
}

yumrepo { 'ambari':
  baseurl => "http://localhost/ambari-2.4.2.0/centos6/2.4.2.0-136",
  descr => "ambari repository",
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
  content => template('ambari-agent.ini'),
  require => Package['ambari-agent']
}

service { 'ambari-agent':
  ensure 		=> running,
  enable 		=> true,
  require => File['/etc/ambari-agent/conf/ambari-agent.ini']
}





