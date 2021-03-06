# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|                                          
  
  # box  
  #config.vm.box = "/dev/vagrant/c66/package.box"
  config.vm.box = "/dev/vagrant/c72/package.box"
  #config.vm.box = "puppetlabs/centos-7.2-64-puppet" 
  
  #local repo dir  
  config.vm.synced_folder '../yum-repo', '/var/www/html', type: 'nfs'
#  config.vm.synced_folder './templates', '/tmp/vagrant-puppet/templates', type: 'nfs'
#  config.vm.synced_folder './log/ambari-server', '/var/log/ambari-server', type: 'nfs' 
#  config.vm.synced_folder './log/ambari-agent', '/var/log/ambari-agent', type: 'nfs' 
  config.vm.synced_folder './log/hadoop', '/var/log/hadoop', type: 'nfs' 
  config.vm.synced_folder './log/hbase', '/var/log/hbase', type: 'nfs' 
  
  #defaul VM settings
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 5120] 
    vb.customize ["modifyvm", :id, "--cpus", 2] 
  end
  
  config.vm.provision :puppet do |puppet|
    puppet.environment_path = "environments"
    puppet.module_path = "modules"
    puppet.manifests_path =  "./manifests/"
    puppet.manifest_file  =  "ambari-agent.pp"
    puppet.options = "--verbose --debug"
  end 

  # c7201
  config.vm.define :c7201 do |c7201|
    
    c7201.vm.hostname = "c7201.barenode.org"
    c7201.vm.network :private_network, ip: "192.168.72.101"    
    c7201.vm.synced_folder './blueprints', '/tmp/vagrant-puppet/blueprints', type: 'nfs'   
    
    c7201.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 9216] 
      vb.customize ["modifyvm", :id, "--cpus", 4] 
    end
    
    c7201.vm.provision :puppet do |puppet|
      puppet.environment_path = "environments"
      puppet.manifests_path =  "./manifests/"
      puppet.manifest_file  =  "ambari-server.pp"
    end     
  end 
  
  # c7202
   config.vm.define :c7202 do |c7202|
     c7202.vm.hostname = "c7202.barenode.org"
     c7202.vm.network :private_network, ip: "192.168.72.102"
   end
  
  # c7203
  config.vm.define :c7203 do |c7203|
    c7203.vm.hostname = "c7203.barenode.org"
    c7203.vm.network :private_network, ip: "192.168.72.103"
  end
  
  # c7204
 config.vm.define :c7204 do |c7204|
    c7204.vm.hostname = "c7204.barenode.org"
    c7204.vm.network :private_network, ip: "192.168.72.104"
  end
      
end
