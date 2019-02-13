# 2019-02-12 (cc) <paul4hough@gmail.com>
#
class maul::grafana(
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
      'firewalld',
      'git'],
    {'ensure' => 'present' })

  create_resources('class', $config )
  create_resources('consul::service', $consul_svc)

  create_resources( 'lvm::volume', $lvm )

  $lvm_vg = lookup('maul::lvm_vg')
  $data_dir =  lookup('maul::grafana_data_dir')
  $mount_dir = dirname( $data_dir )
  ensure_resource( 'file', $mount_dir, { ensure => 'directory' })

  mount { $mount_dir:
    ensure => 'mounted',
    device => "/dev/${lvm_vg}/lv_grafana",
    fstype => 'xfs',
    atboot => true,
    dump   => 0,
    pass   => 2,
  }
  # grafana defaults to package install
  # which creates the grafana user
  ensure_resource(
    'file', $data_dir,
    {
      ensure  => 'directory',
      owner   => 'grafana',
      group   => 'grafana',
      mode    => '0775',
      require => Package['grafana']
    }
  )

  ensure_resource(
    'service',
    'firewalld',
    { ensure => 'running',enable => true})

  create_resources( 'firewalld::custom_service', $firewall_cs )
  create_resources( 'firewalld_service', $firewall_svc )

  Package['unzip']
  -> Package['e2fsprogs']
  -> Package['lvm2']
  -> Package['firewalld']
  -> Package['git']
  -> Lvm::Volume['lv_grafana']
  -> Mount[$mount_dir]
  -> Class['grafana']
  -> Service['firewalld']
  -> Firewalld::Custom_service['grafana']
  -> Firewalld_service['grafana']

}
