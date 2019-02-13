# 2019-02-12 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::grafana'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       "grafana",
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
      ['unzip',
       'e2fsprogs',
       'lvm2',
       'firewalld',
       'git',
      ].each { |pkg|
        it { is_expected.to contain_package(pkg)}
      }
      it { is_expected.to contain_consul__service('grafana') }
      it { is_expected.to contain_lvm__volume('lv_grafana') }
      it { is_expected.to contain_file('/opt/grafana') }
      it { is_expected.to contain_mount('/opt/grafana') }
      it { is_expected.to contain_file('/opt/grafana/data') }
      it { is_expected.to contain_firewalld__custom_service('grafana') }
      it { is_expected.to contain_firewalld_service('grafana') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
