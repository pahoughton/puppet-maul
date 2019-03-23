# 2019-03-22 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::exporter::postgres'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       'prometheus::postgres_exporter',
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
      it { is_expected.to contain_consul__service('postgres_exporter') }
      it {
        is_expected.to contain_firewalld__custom_service('postgres_exporter')
      }
      it { is_expected.to contain_firewalld_service('postgres_exporter') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
