# 2019-02-09 (cc) <paul4hough@gmail.com>
#
class maul::consul(
  $config,
  $firewall_cs,
  $firewall_svc,
) {

  ensure_packages(
    [ 'unzip',
      'firewalld'
    ],
    { ensure => 'present' })

  create_resources('class', $config)

  ensure_resource(
    'service','firewalld',
    {
      ensure => 'running',
      enable => true
    }
  )

  create_resources('firewalld::custom_service', $firewall_cs)
  create_resources('firewalld_service', $firewall_svc)

  Package['unzip']
  -> Package['firewalld']
  -> Class['consul']
  -> Service['firewalld']
  -> Firewalld::Custom_service['consul']
  -> Firewalld_service['consul']

}
