# 2019-02-09 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::promfed'
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
       'git'].each { |pkg|
        it { is_expected.to contain_package(pkg)}
      }
      it { is_expected.to contain_consul__service('promfed') }
      it { is_expected.to contain_lvm__volume('lv_prometheus') }
      it { is_expected.to contain_file('/opt/prometheus') }
      it { is_expected.to contain_mount('/opt/prometheus') }
      it { is_expected.to contain_firewalld__custom_service('prometheus') }
      it { is_expected.to contain_firewalld_service('prometheus') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
