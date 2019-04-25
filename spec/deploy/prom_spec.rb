# 2019-04-23 (cc) <paul4hough@gmail.com>
#
#require 'airborne'
require 'rest-client'
require 'json'

host ='10.0.7.5'
port = '9090'
utargets = "http://#{host}:#{port}/api/v1/targets"

pjobs = {
  'scale' => [ 'node', 'prometheus'],
}
pjobs['default'] = pjobs['scale'] + [
  'agate',
  'alertmanager',
  'consul',
  'grafana',
]
pjobs['maul'] = pjobs['default'] + [
  'gitlab',
  'hpsm',
  'cloudera',
]

pp pjobs

describe 'prometheus targets' do
  resp = JSON.parse(RestClient.get(utargets))
  context 'status' do
    it { expect(resp['status']).to eq('success') }
  end
  tlist = resp['data']['activeTargets']
  pjobs['default'].each { |j|
    jtlist = tlist.select {|t| t['labels']['job'] == j}
    context "#{j} job count" do
      it { expect(jtlist.length).to be > 0 }
    end
  }
  context 'targets' do
    tlist.each { |t|
      node = t['labels']['node'] ?
               t['labels']['node'] :
               t['discoveredLabels']['__meta_consul_node'] ?
                 t['discoveredLabels']['__meta_consul_node'] :
                 t['labels']['instance']
      context "#{node} " + t['labels']['job'] + " health" do
        it { expect(t['health']).to eq('up') }
      end
    }
  end
end
