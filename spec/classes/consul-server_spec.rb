# 2019-02-09 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::consul::server'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       "maul::consul",
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
      ['e2fsprogs',
       'lvm2',
      ].each { |pkg|
        it { is_expected.to contain_package(pkg)}
      }
      it { is_expected.to contain_lvm__volume('lv_consul') }
      it { is_expected.to contain_file('/opt/consul') }
      it { is_expected.to contain_mount('/opt/consul') }
    end
  end
end
