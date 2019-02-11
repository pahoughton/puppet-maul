# 2019-02-09 (cc) <paul4hough@gmail.com>
#
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.fail_fast       = true
  c.default_facts   = {
    # :kernel => 'Linux',
    # :os     => {
    #   :family => 'RedHat',
    #   :release => {
    #     :major => '7'
    #   }
    # },
    # :ipaddress_lo               => '127.0.0.1',
    # :osfamily                   => 'RedHat',
    # :operatingsystem            => 'CentOS',
    # :operatingsystemmajrelease  => '7',
    # :architecture               => 'x86_64',

    :firewall_zone     => 'external',
    :datacenter        => 'maul',
    :servertype        => 'testbed',
    :mongrp            => 'mon-01',
    :prom_mongrp       => 'mon-01',
    :consul_server     => '10.0.7.5',
  }
end

require 'spec_helper_methods'
