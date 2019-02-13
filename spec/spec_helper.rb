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

    :firewall_zone     => 'external',
    :datacenter        => 'maul',
    :servertype        => 'testbed',
    :mongrp            => 'mon-01',
    :prom_mongrp       => 'mon-01',
    :consul_server     => '10.0.7.5',

    :maul_alert_agate        => true,
    :maul_alert_alertmanager => true,
    :maul_alert_cloudera     => true,
    :maul_alert_consul       => true,
    :maul_alert_grafana      => true,
    :maul_alert_hpsm         => true,
    :maul_alert_sysv         => true,
  }
end

require 'spec_helper_methods'
