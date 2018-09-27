# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
vconfig = YAML::load_file("./vagrant_config.yml")

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # Since proxy not initially setup, update of guest additions will fail.
  # Once VM is provisioned, run vagrant vbguest to manually install or update guest additions.
  config.vbguest.auto_update = false

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "centos/6"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL


  config.vm.define vconfig['vm']['workspace']['name'] do |node|
  
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    node.vm.box = vconfig['vm']['box']
    node.vm.hostname = vconfig['vm']['workspace']['name'] + vconfig['vm']['domainName']
    node.vm.boot_timeout = 900
     
    node.vm.provision :shell, path: "bootstrap-base.sh", args: [vconfig['vm']['osVersion'],vconfig['vm']['proxyExists'],vconfig['vm']['bootstrapperHome'],vconfig['vm']['infrastructure']]
    
    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    node.vm.network "private_network", ip: vconfig['vm']['workspace']['internalip']
    
    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    node.vm.network "public_network", :bridge => vconfig['vm']['bridgeNetworkAdapter']

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    # config.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
    #   vb.memory = "1024"
    # end
    #
    # View the documentation for the provider you are using for more
    # information on available options.

   
    node.vm.provider "virtualbox" do |vb|
      vb.name = vconfig['vm']['workspace']['name']
      vb.memory = vconfig['vm']['workspace']['memory']
    end      
    
  end

  config.vm.define vconfig['vm']['master']['name'] do |node|
  
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    node.vm.box = vconfig['vm']['box']
    node.vm.hostname = vconfig['vm']['master']['name'] + vconfig['vm']['domainName']
     
    node.vm.provision :shell, path: "bootstrap-base.sh", args: [vconfig['vm']['osVersion'],vconfig['vm']['proxyExists'],vconfig['vm']['bootstrapperHome'],vconfig['vm']['infrastructure']]
    
    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    node.vm.network "private_network", ip: vconfig['vm']['master']['internalip']
    
    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    node.vm.network "public_network", :bridge => vconfig['vm']['bridgeNetworkAdapter']

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    # config.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
    #   vb.memory = "1024"
    # end
    #
    # View the documentation for the provider you are using for more
    # information on available options.

   
    node.vm.provider "virtualbox" do |vb|
      vb.name = vconfig['vm']['master']['name']
      vb.memory = vconfig['vm']['master']['memory']
    end      
    
  end

  numNodes = vconfig['vm']['worker']['numOfNodes']
  ipAddrPrefix = vconfig['vm']['worker']['internalbaseip']

  1.upto(numNodes) do |num|
    nodeName = (vconfig['vm']['worker']['prefixName'] + num.to_s + vconfig['vm']['worker']['suffixName']).to_sym 
    config.vm.define nodeName do |node|

      node.vm.box = vconfig['vm']['box']
      node.vm.hostname = nodeName.to_s + vconfig['vm']['domainName']

      node.vm.provision :shell, path: "bootstrap-base.sh", args: [vconfig['vm']['osVersion'],vconfig['vm']['proxyExists'],vconfig['vm']['bootstrapperHome'],vconfig['vm']['infrastructure']]
    
      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      node.vm.network "private_network", ip: ipAddrPrefix + num.to_s
    
      # Create a public network, which generally matched to bridged network.
      # Bridged networks make the machine appear as another physical device on
      # your network.
      node.vm.network "public_network", :bridge => vconfig['vm']['bridgeNetworkAdapter']
  
      node.vm.provider "virtualbox" do |vb|
        vb.name = nodeName.to_s
        vb.memory = vconfig['vm']['worker']['memory']
      end      

    end
  end

end
