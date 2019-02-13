# 2019-02-09 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::prometheus'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       'prometheus::server',
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
      ['unzip',
       'e2fsprogs',
       'lvm2',
       'firewalld',
       'git'].each { |pkg|
        it { is_expected.to contain_package(pkg)}
      }
      it { is_expected.to contain_vcsrepo('/etc/prometheus/rules') }
      it { is_expected.to contain_file('/etc/prometheus/targets') }
      it { is_expected.to contain_file('/etc/prometheus/targets/cloudera.json') }
      it { is_expected.to contain_file('/etc/prometheus/targets/hpsm.json') }
      it { is_expected.to contain_consul__service('prometheus') }
      it { is_expected.to contain_lvm__volume('lv_prometheus') }
      it { is_expected.to contain_file('/opt/prometheus') }
      it { is_expected.to contain_mount('/opt/prometheus') }
      it { is_expected.to contain_firewalld__custom_service('prometheus') }
      it { is_expected.to contain_firewalld_service('prometheus') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
