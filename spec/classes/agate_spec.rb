# 2019-02-11 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul::agate'

describe tobj, :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      [tobj,
       'agate',
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
      it { is_expected.to contain_vcsrepo('/etc/agate/scripts') }
      it { is_expected.to contain_consul__service('agate') }
      it { is_expected.to contain_lvm__volume('lv_agate') }
      it { is_expected.to contain_file('/opt/agate') }
      it { is_expected.to contain_mount('/opt/agate') }
      it { is_expected.to contain_firewalld__custom_service('agate') }
      it { is_expected.to contain_firewalld_service('agate') }
      it { is_expected.to contain_service('firewalld') }
    end
  end
end
