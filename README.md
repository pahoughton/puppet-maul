## puppet-maul

[![Test Build Status](https://travis-ci.org/pahoughton/puppet-maul.png)]
(https://travis-ci.org/pahoughton/puppet-maul)

Maul is monitoring and alerting system that utilizes the prometheus
tool set, consul and agate to generates tickets for defects.

## features

* maul::consul
* maul::consul::server
* maul::prometheus
* maul::alertmanager
* maul::agate
* maul::grafana
* maul::exporter::node
* maul::exporter::blackbox
* maul::exporter::consul
* maul::exporter::postgres
* maul::exporter::process

## usage

### configuration

See hiera [data](../master/data)

### custom facts used

* firewall_zone
* datacenter
* servertype
* mongrp
* prom_mongrp
* consul_server

## contribute

https://github.com/pahoughton/puppet-maul

## licenses

2019-02-09 (cc) <paul4hough@gmail.com>

GNU General Public License v3.0

See [COPYING](../master/COPYING) for full text.
