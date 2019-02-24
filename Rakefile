# 2019-01-06 (cc) <paul4hough@gmail.com>
#
require 'puppetlabs_spec_helper/rake_tasks'

$runstart = Time.now

at_exit {
  runtime = Time.at(Time.now - $runstart).utc.strftime("%H:%M:%S.%3N")
  puts "run time: #{runtime}"
}

desc 'yamllint data'
task :yamllint do
  sh "yamllint -f parsable" +\
     " .fixtures.yml" +\
     " .travis.yml" +\
     " hiera.yaml" +\
     " data"
end

desc 'all test'
task :test => [:yamllint,:lint,:validate,:spec]

desc 'travis-ci tasks'
task :travis => [:lint,:validate,:spec]
