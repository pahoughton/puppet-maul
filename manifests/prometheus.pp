# 2019-02-10 (cc) <paul4hough@gmail.com>
#
class maul::prometheus(
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

  $prom_notify = Class['prometheus::service_reload']

  # shorteners
  $targdir = "${lookup('maul::prometheus_config_dir')}/targets"
  $cls = 'prometheus::server'
  $scr = 'scrape_configs'
  $rul = 'rule_files'

  $mon_agate = pick(
    $facts['maul_prom_agate'],
    lookup('maul::prom_agate'))

  if $mon_agate {
    $cfg_agate = {
      'prometheus::server' => {
        scrape_configs  => $config[$cls][$scr] << lookup('maul::scrape_agate'),
        rule_files      => $config[$cls][$rul] << 'rules/alerts/agate/*.yml'
      }
    }
  } else {
    $cfg_agate = $config
  }

  $mon_alertmanager = pick(
    $facts['maul_prom_alertmanager'],
    lookup('maul::prom_alertmanager'))

  if $mon_alertmanager {
    $cfg_amgr = {
      'prometheus::server' => {
        scrape_configs  => $cfg_agate[$cls][$scr] << lookup('maul::scrape_alertmanager'),
        rule_files      => $cfg_agate[$cls][$rul] << 'rules/alerts/alertmanager/*.yml'
      }
    }
  } else {
    $cfg_amgr = $cfg_agate
  }

  $mon_cloudera = pick(
    $facts['maul_prom_cloudera'],
    lookup('maul::prom_cloudera'))

  if $mon_cloudera {
    $cfg_cloudera = {
      'prometheus::server' => {
        scrape_configs  => $cfg_amgr[$cls][$scr] << lookup('maul::scrape_cloudera'),
        rule_files      => $cfg_amgr[$cls][$rul] << 'rules/alerts/cloudera/*.yml'
      }
    }
    $cloudera_targets = lookup('maul::bbox_cloudera_targets')
    file { "${targdir}/cloudera.json":
      ensure  => 'present',
      owner   => 'prometheus',
      group   => 'prometheus',
      mode    => '0664',
      content => template('maul/targets-cloudera.json.erb'),
    }
  } else {
    $cfg_cloudera = $cfg_amgr
  }

  $mon_consul = pick(
    $facts['maul_prom_consul'],
    lookup('maul::prom_consul'))

  if $mon_consul {
    $cfg_consul = {
      'prometheus::server' => {
        scrape_configs  => $cfg_cloudera[$cls][$scr] << lookup('maul::scrape_consul'),
        rule_files      => $cfg_cloudera[$cls][$rul] << 'rules/alerts/consul/*.yml'
      }
    }
  } else {
    $cfg_consul = $cfg_cloudera
  }

  $mon_grafana = pick(
    $facts['maul_prom_grafana'],
    lookup('maul::prom_grafana'))

  if $mon_grafana {
    $cfg_grafana = {
      'prometheus::server' => {
        scrape_configs  => $cfg_consul[$cls][$scr] << lookup('maul::scrape_grafana'),
        rule_files      => $cfg_consul[$cls][$rul] << 'rules/alerts/grafana/*.yml'
      }
    }
  } else {
    $cfg_grafana = $cfg_consul
  }

  $mon_hpsm = pick(
    $facts['maul_prom_hpsm'],
    lookup('maul::prom_hpsm'))

  if $mon_hpsm {
    $cfg_hpsm = {
      'prometheus::server' => {
        scrape_configs  => $cfg_grafana[$cls][$scr] << lookup('maul::scrape_hpsm'),
        rule_files      => $cfg_grafana[$cls][$rul] << 'rules/alerts/hpsm/*.yml'
      }
    }
    $hpsm_targets = lookup('maul::bbox_hpsm_targets')
    file { "${targdir}/hpsm.json":
      ensure  => 'present',
      owner   => 'prometheus',
      group   => 'prometheus',
      mode    => '0664',
      content => template('maul/targets-hpsm.json.erb'),
    }
  } else {
    $cfg_hpsm = $cfg_grafana
  }

  $mon_sysv = pick(
    $facts['maul_prom_sysv'],
    lookup('maul::prom_sysv'))

  if $mon_sysv {
    $cfg_sysv = {
      'prometheus::server' => {
        scrape_configs  => $cfg_hpsm[$cls][$scr] << lookup('maul::scrape_sysv'),
        rule_files      => $cfg_hpsm[$cls][$rul] << 'rules/alerts/sysv/*.yml'
      }
    }
  } else {
    $cfg_sysv = $cfg_hpsm
  }

  $cfg_prom = deep_merge(
    $config,
    $cfg_sysv)

  create_resources( 'class', $cfg_prom )

  file { $targdir:
    ensure => 'directory',
    owner  => 'prometheus',
    group  => 'prometheus',
    mode   => '0775',
  }

  # FIXME - yaml'ize notify?
  $cfgdir = lookup('maul::prometheus_config_dir')
  vcsrepo { "${cfgdir}/rules":
    ensure   => 'present',
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
  -> Package['firewalld']
  -> Package['git']
  -> Lvm::Volume['lv_prometheus']
  -> Mount[$prom_mp]
  -> Class['prometheus::server']
  -> Service['firewalld']
  -> Firewalld::Custom_service['prometheus']
  -> Firewalld_service['prometheus']

}
