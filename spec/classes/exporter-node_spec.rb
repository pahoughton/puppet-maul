# 2019-02-12 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::exporter::node'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       'prometheus::node_exporter',
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
      it { is_expected.to contain_consul__service('node_exporter') }
      it { is_expected.to contain_firewalld__custom_service('node_exporter') }
      it { is_expected.to contain_firewalld_service('node_exporter') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
