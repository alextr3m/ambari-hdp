# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|                                          
  
  # box  
  config.vm.box = "/dev/vagrant/c66/package.box"
  #config.vm.box = "puppetlabs/centos-6.6-64-puppet"      
  #config.vm.box_version = "1.0.1"  
  
  #local repo dir  
  config.vm.synced_folder '../yum-repo', '/var/www/html', type: 'nfs'
  config.vm.synced_folder './templates', '/tmp/vagrant-puppet/templates', type: 'nfs'
  config.vm.synced_folder './log/hadoop', '/var/log/hadoop', type: 'nfs' 
  config.vm.synced_folder './log/hbase', '/var/log/hbase', type: 'nfs' 
  
  #defaul VM settings
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 5120] 
    vb.customize ["modifyvm", :id, "--cpus", 2] 
  end
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path =  "./manifests/"
    puppet.manifest_file  =  "ambari-agent.pp"
    puppet.options = "--verbose --debug --templatedir /tmp/vagrant-puppet/templates"
  end 

  # c6601
  config.vm.define :c6601 do |c6601|
    
    c6601.vm.hostname = "c6601.barenode.org"
    c6601.vm.network :private_network, ip: "192.168.66.101"    
    c6601.vm.synced_folder './blueprints', '/tmp/vagrant-puppet/blueprints', type: 'nfs'   
    
    c6601.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 9216] 
      vb.customize ["modifyvm", :id, "--cpus", 4] 
    end
    
    c6601.vm.provision :puppet do |puppet|
      puppet.manifests_path =  "./manifests/"
      puppet.manifest_file  =  "ambari-server.pp"
    end     
  end 
  
  # c6602
 #  config.vm.define :c6602 do |c6602|
 #    c6602.vm.hostname = "c6602.barenode.org"
 #    c6602.vm.network :private_network, ip: "192.168.66.102"
 #  end
  
  # c6603
 # config.vm.define :c6603 do |c6603|
 #   c6603.vm.hostname = "c6603.barenode.org"
 #   c6603.vm.network :private_network, ip: "192.168.66.103"
 # end
  
  # c6604
 # config.vm.define :c6604 do |c6604|
 #   c6604.vm.hostname = "c6604.barenode.org"
 #   c6604.vm.network :private_network, ip: "192.168.66.104"
#  end
      
end
