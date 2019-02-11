# 2019-02-09 (cc) <paul4hough@gmail.com>
#
class maul_testbed_role {

  include 'maul::consul::server'
  include 'maul::prometheus'

#  Class['maul::consul::server']
#  -> Class['maul::prometheus']

}
