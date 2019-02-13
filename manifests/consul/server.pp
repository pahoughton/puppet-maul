# 2019-02-09 (cc) <paul4hough@gmail.com>
#
class maul::consul::server(
  $config,
  $lvm,
  $server_cfg,
) {

  ensure_packages(
    [ 'e2fsprogs',
      'lvm2'],
    { ensure => 'present' })

  $maul_consul = {
    'maul::consul' => {
      config => deep_merge($config,$server_cfg),
    }
  }
  create_resources('class', $maul_consul)

  Package['e2fsprogs']
  -> Package['lvm2']
  -> Lvm::Volume['lv_consul']

  create_resources('lvm::volume', $lvm)

  $lvm_vg = lookup('maul::lvm_vg')

  # work around mount setting owner to root
  $consul_mp = dirname( lookup('maul::consul_data_dir') )
  ensure_resource( 'file', $consul_mp, { ensure => 'directory' })
  mount { $consul_mp:
    ensure  => 'mounted',
    device  => "/dev/${lvm_vg}/lv_consul",
    fstype  => 'xfs',
    atboot  => true,
    dump    => 0,
    pass    => 2,
    require => Lvm::Volume['lv_consul'],
    before  => Class['consul'],
  }

}
