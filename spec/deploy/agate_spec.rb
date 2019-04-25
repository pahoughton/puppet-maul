# 2019-04-23 (cc) <paul4hough@gmail.com>
#
require 'airborne'

host ='10.0.7.5'
port = '4464'

describe 'agate' do
  it 'should provide /metrics' do
    get "http://#{host}:#{port}/metrics"
    ['agate_amgr_errors',
     'agate_db_errors_total',
     'agate_notify_errors',
     'agate_remed_errors',
     'agate_remed_queue',
     'agate_remed_queue_max',
    ].each { |m|
      expect(body).to include(m)
    }
  end
end
