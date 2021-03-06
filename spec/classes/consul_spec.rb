# 2019-02-09 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::consul'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       "consul",
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
      ['unzip',
       'firewalld'
      ].each { |pkg|
        it { is_expected.to contain_package(pkg)}
      }
      it { is_expected.to contain_firewalld__custom_service('consul') }
      it { is_expected.to contain_firewalld_service('consul') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
