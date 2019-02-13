# 2018-12-23 (cc) <paul4hough@gmail.com>
#

Vagrant.configure("2") do |config|
  # config.vm.box_check_update = false

  maul = 'maul'
  config.vm.define maul do |bcfg|
    bcfg.vm.box = "c7g-puppet"

    bcfg.vm.hostname    = maul
    bcfg.vm.network    'private_network', ip: '10.0.7.5'
    # bcfg.vm.network "forwarded_port", guest: 9090, host: 9090
    # bcfg.vm.network "forwarded_port", guest: 9093, host: 9093
    bcfg.vm.provider   'virtualbox' do |vb|
      vb.name      = maul
      vb.cpus      = 2
      vb.memory    = 4096
      # vb.cpus      = 1
      # vb.memory    = 1024
      vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      vb.customize ['modifyvm', :id, '--natdnspassdomain1', 'on']
      vb.customize ['modifyvm', :id, '--usb', 'off']
      # second drive for lvm
      sdb = "sdb.vdi"
      unless File.exist?(sdb)
        vb.customize ['createhd',
                      '--filename',sdb,
                      '--size',20 * 1024]
      end
      vb.customize ['storageattach', :id,
                    '--storagectl', 'IDE',
                    '--port', 0, '--device', 1,
                    '--type', 'hdd',
                    '--medium', sdb]
    end
    bcfg.vm.provision "puppet" do |puppet|
      # puppet.options        = '--debug --verbose'
      puppet.options        = '--verbose'
      puppet.manifests_path = ['vm','/vagrant/puppet']
      puppet.manifest_file  = 'maul.pp'
      puppet.module_path    = 'puppet/modules'
      puppet.facter         = {
        'firewall_zone'     => 'public',
        'datacenter'        => 'maul',
        'servertype'        => 'testbed',
        'mongrp'            => 'mon-01',
        'prom_mongrp'       => 'mon-01',
        'consul_server'     => '10.0.7.5',
        'maul_agate_node'   => '10.0.7.5',

        'maul_alert_agate'        => true,
        'maul_alert_alertmanager' => true,
        'maul_alert_cloudera'     => true,
        'maul_alert_consul'       => true,
        'maul_alert_grafana'      => true,
        'maul_alert_hpsm'         => true,
        'maul_alert_sysv'         => true,
      }
    end
  end

end
