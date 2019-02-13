# 2019-02-09 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::alertmanager'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       'prometheus::alertmanager'
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
      ['unzip',
       'e2fsprogs',
       'lvm2',
       'firewalld'
      ].each { |pkg|
        it { is_expected.to contain_package(pkg)}
      }
      it { is_expected.to contain_consul__service('alertmanager') }
      it { is_expected.to contain_lvm__volume('lv_alertmanager') }
      it { is_expected.to contain_file('/opt/alertmanager') }
      it { is_expected.to contain_mount('/opt/alertmanager') }
      it { is_expected.to contain_firewalld__custom_service('alertmanager') }
      it { is_expected.to contain_firewalld_service('alertmanager') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
