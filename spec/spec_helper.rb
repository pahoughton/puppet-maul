# 2019-02-09 (cc) <paul4hough@gmail.com>
#
RSpec.configure do |c|
  c.mock_with :rspec
end
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.fail_fast       = true
  c.default_facts   = {
    'maul_consul_retry'       => ['10.0.7.6',
                                  '10.0.7.7',],
    'maul_firewall_zone'      => 'public',
    'maul_datacenter'         => 'dc-maul',
    'maul_servertype'         => 'maul',
    'maul_mongrp'             => 'a-1',
    'maul_prom_mongrp'        => 'a-1',
    'maul_agate_node'         => '10.0.7.5',
    'maul_vg_dev'             => '/dev/sdb',
    'maul_alert_agate'        => true,
    'maul_alert_alertmanager' => true,
    'maul_alert_cloudera'     => true,
    'maul_alert_consul'       => true,
    'maul_alert_grafana'      => true,
    'maul_alert_hpsm'         => true,
    'maul_alert_sysd'         => true,
    'maul_alert_sysv'         => true,
  }
end

require 'spec_helper_methods'
