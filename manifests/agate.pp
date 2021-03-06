# 2019-02-11 (cc) <paul4hough@gmail.com>
#
class maul::agate(
  $config,
  $lvm,
  $consul_svc,
  $firewall_cs,
  $firewall_svc,
  $vcs_scripts,
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

  $scripts_dir = "${lookup('maul::agate_config_dir')}/scripts"
  create_resources('vcsrepo', $vcs_scripts)

  create_resources( 'lvm::volume', $lvm )

  $lvm_vg = lookup('maul::lvm_vg')
  $agate_mp = dirname( lookup('maul::agate_data_dir') )
  ensure_resource('file',$agate_mp, { ensure => 'directory' })
  mount { $agate_mp:
    ensure => 'mounted',
    device => "/dev/${lvm_vg}/lv_agate",
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
  -> Package['git']
  -> Lvm::Volume['lv_agate']
  -> Mount[$agate_mp]
  -> Class['agate']
  -> Vcsrepo[$scripts_dir]
  -> Service['firewalld']
  -> Firewalld::Custom_service['agate']
  -> Firewalld_service['agate']
}
