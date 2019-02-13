# 2019-02-12 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::exporter::blackbox'
describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       "prometheus::blackbox_exporter",
      ].each { |cls|
        it { is_expected.to contain_class(cls) }
      }
    end
  end
end
