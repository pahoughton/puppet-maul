# 2019-02-09 (cc) <paul4hough@gmail.com>
#
require 'spec_helper'

tobj = 'maul'
describe tobj, :type => :class do
  [tobj,
  ].each { |cls|
    it { is_expected.to contain_class(cls) }
  }
end
