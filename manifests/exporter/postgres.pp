# 2019-03-22 (cc) <paul4hough@gmail.com>
#
class maul::exporter::postgres(
  Hash $config,
  Hash $consul_svc,
  Hash $firewall_cs,
  Hash $firewall_svc,
) {

  create_resources('class', $config )
  create_resources('consul::service', $consul_svc)

  ensure_resource(
    'service','firewalld',
    { ensure => 'running',enable => true})
  create_resources( 'firewalld::custom_service', $firewall_cs )
  create_resources( 'firewalld_service', $firewall_svc )

  Class['prometheus::postgres_exporter']
  -> Service['firewalld']
  -> Firewalld::Custom_service['postgres_exporter']
  -> Firewalld_service['postgres_exporter']
}
