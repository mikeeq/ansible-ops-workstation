# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 2.0.0"

ENV["LC_ALL"] = "en_US.UTF-8"
require 'yaml'
CURRENT_DIR=File.dirname(__FILE__)
hosts = YAML.load_file("#{CURRENT_DIR}/inventory/vagrant.yml")['hosts']

Vagrant.configure("2") do |config|
  hosts.each do |host|
    config.ssh.forward_x11 = true
    config.vm.box_check_update = false
    config.vm.define host['name'] do |vm_config|
      vm_config.vm.box = "#{host['os']}"
      vm_config.vm.hostname = host['hostname']
        host['ip'].each do |address|
          vm_config.vm.network :private_network, ip: address
        end
      # vm_config.hostmanager.aliases = host['hostname_alias']
      vm_config.vm.provider "virtualbox" do |vbox|
        vbox.linked_clone = true
        vbox.gui = false
        vbox.name = "#{vm_config.vm.hostname}"
        vbox.customize ["modifyvm", :id, "--memory", "#{host['mem']}"]
        vbox.customize ["modifyvm", :id, "--cpus", "#{host['cpu']}"]
        vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end
      config.vm.provider :libvirt do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.cpus = "#{host['cpu']}"
        libvirt.memory = "#{host['mem']}"
        libvirt.nested = true
        libvirt.cpu_mode = "host-passthrough"
      end
      if !host['port_forward'].empty? then
        host['port_forward'].each do |forward_rule|
          vm_config.vm.network "forwarded_port", guest: forward_rule['guest'], host: forward_rule['host'], auto_correct: true
        end
      end
      # # Ansible provisioner.
      # vm_config.vm.provision "ansible" do |ansible|
      #   ansible.playbook = "fedora.yml"
      #   ansible.config_file = "ansible.cfg"
      #   ansible.compatibility_mode = "2.0"
      #   ansible.inventory_path = "inventory/hosts.yml"
      #   ansible.raw_arguments =
      #     [
      #       # "-vvv",
      #     ]
      #   ansible.extra_vars = {
      #     hosts_to_deploy: "#{host['name']}",
      #   }
      # end
    end
  end
end
