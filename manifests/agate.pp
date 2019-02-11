# 2019-02-11 (cc) <paul4hough@gmail.com>
#
class maul::agate(
  $config,
  $lvm,
  $firewall_cs,
  $firewall_svc
) {
  ensure_packages(
    [ 'unzip',
      'e2fsprogs',
      'lvm2',
      'firewalld',
      'git'],
    {'ensure' => 'present' })

  create_resources( 'class', $config )

  $basedir = lookup('maul::agate_base_dir')
  vcsrepo { "${basedir}/scripts":
    ensure   => 'present',
    provider => 'git',
    source   => lookup('maul::agate_scripts_repo'),
    require  => [Class['agate'],
                 Package['git']],
  }

  create_resources(
    'consul::service',
    {
      'agate' => {
        port => lookup('maul::agate_port')
      }
    }
  )
  create_resources( 'lvm::volume', $lvm )

  $lvm_vg = lookup('maul::lvm_vg')
  $agate_mp = dirname( lookup('maul::agate_data_dir') )
  ensure_resource( 'file', $amgr_mp, { ensure => 'directory' })
  mount { $amgr_mp:
    ensure  => 'mounted',
    device  => "/dev/${lvm_vg}/lv_agate",
    fstype  => 'xfs',
    atboot  => true,
    dump    => 0,
    pass    => 2,
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
  -> Service['firewalld']
  -> Firewalld::Custom_service['agate']
  -> Firewalld_service['agate']
}
