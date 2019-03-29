# 2019-03-29 (cc) <paul4hough@gmail.com>
#
class maul::promfed(
  $config,
  $lvm,
  $consul_svc,
  $firewall_cs,
  $firewall_svc,
) {

  ensure_packages(
    [ 'unzip',
      'e2fsprogs',
      'lvm2',
      'git'],
    {'ensure' => 'present' })

  $prom_notify = Class['prometheus::service_reload']

  create_resources( 'class', $config )

  vcsrepo { "${lookup('maul::prometheus_config_dir')}/rules":
    ensure   => 'latest',
    provider => 'git',
    source   => lookup('maul::prometheus_rules_repo'),
    require  => [ Class['prometheus::config'],
                  Package['git']],
    notify   => $prom_notify,
  }

  create_resources('consul::service', $consul_svc)

  create_resources( 'lvm::volume', $lvm )

  $lvm_vg = lookup('maul::lvm_vg')
  $prom_mp = dirname( lookup('maul::prometheus_data_dir') )
  ensure_resource( 'file', $prom_mp, { ensure => 'directory' })
  mount { $prom_mp:
    ensure => 'mounted',
    device => "/dev/${lvm_vg}/lv_prometheus",
    fstype => 'xfs',
    atboot => true,
    dump   => 0,
    pass   => 2,
  }

  ensure_resource(
    'service','firewalld',
    { ensure => 'running',enable => true})

  create_resources( 'firewalld::custom_service', $firewall_cs )
  create_resources( 'firewalld_service', $firewall_svc )

  Package['unzip']
  -> Package['e2fsprogs']
  -> Package['lvm2']
  -> Package['git']
  -> Lvm::Volume['lv_prometheus']
  -> Mount[$prom_mp]
  -> Class['prometheus::server']
  -> Service['firewalld']
  -> Firewalld::Custom_service['prometheus']
  -> Firewalld_service['prometheus']

}
