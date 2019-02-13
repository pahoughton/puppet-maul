# 2019-02-11 (cc) <paul4hough@gmail.com>
#
class maul::alertmanager(
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
      'firewalld'],
    {'ensure' => 'present' })

  create_resources('class', $config )
  create_resources('consul::service', $consul_svc)

  create_resources( 'lvm::volume', $lvm )

  $lvm_vg = lookup('maul::lvm_vg')
  $amgr_mp = dirname( lookup('maul::alertmanager_data_dir') )
  ensure_resource( 'file', $amgr_mp, { ensure => 'directory' })
  mount { $amgr_mp:
    ensure => 'mounted',
    device => "/dev/${lvm_vg}/lv_alertmanager",
    fstype => 'xfs',
    atboot => true,
    dump   => 0,
    pass   => 2,
  }

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
  -> Lvm::Volume['lv_alertmanager']
  -> Mount[$amgr_mp]
  -> Class['prometheus::alertmanager']
  -> Service['firewalld']
  -> Firewalld::Custom_service['alertmanager']
  -> Firewalld_service['alertmanager']

}
