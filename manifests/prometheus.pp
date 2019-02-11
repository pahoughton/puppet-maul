# 2019-02-10 (cc) <paul4hough@gmail.com>
#
class maul::prometheus(
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

  $alert_base = {
    'prometheus::server' => {
      rule_files => [ 'rules/alerts/base/*.yml',
                      'rules/alerts/systemd/*.yml', ],
    }
  }

  if $facts['maul_alert_sysv'] == true {
    $alert_sysv = {
      'prometheus::server' => {
        scrape_configs  => lookup('maul::scrape_sysv'),
        rule_files      => ['rules/alerts/sysv/*.yml']
      }
    }
  } else {
    $alert_sysv = {}
  }

  if $facts['maul_alert_cloudera'] == true {
    $alert_cloudera = {
      'prometheus::server' => {
        scrape_configs  => lookup('maul::scrape_cloudera'),
        rule_files      => ['rules/alerts/cloudera/*.yml']
      }
    }
  } else {
    $alert_cloudera = {}
  }

  $prom_cfg = deep_merge(
    $config,
    $alert_base,
    $alert_sysv,
    $alert_cloudera)

  $prom_notify = Class['prometheus::service_reload']

  create_resources( 'class', $prom_cfg )

  $cfgdir = lookup('maul::prometheus_config_dir')
  vcsrepo { "${cfgdir}/rules":
    ensure   => 'present',
    provider => 'git',
    source   => lookup('maul::prometheus_rules_repo'),
    require  => [Class['prometheus::config'],
                 Package['git']],
    notify   => $prom_notify,
  }

  create_resources(
    'consul::service',
    {
      'prometheus' => {
        port => '9090',
      }
    }
  )

  create_resources( 'lvm::volume', $lvm )

  $lvm_vg = lookup('maul::lvm_vg')
  $prom_mp = dirname( lookup('maul::prometheus_data_dir') )
  ensure_resource( 'file', $prom_mp, { ensure => 'directory' })
  mount { $prom_mp:
    ensure  => 'mounted',
    device  => "/dev/${lvm_vg}/lv_prometheus",
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
  -> Lvm::Volume['lv_prometheus']
  -> Mount[$prom_mp]
  -> Class['prometheus::server']
  -> Service['firewalld']
  -> Firewalld::Custom_service['prometheus']
  -> Firewalld_service['prometheus']

}
