# 2019-01-06 (cc) <paul4hough@gmail.com>
#
require 'puppetlabs_spec_helper/rake_tasks'

$runstart = Time.now

at_exit {
  runtime = Time.at(Time.now - $runstart).utc.strftime("%H:%M:%S.%3N")
  puts "run time: #{runtime}"
}

task :yamllint do
  sh "yamllint -f parsable" +\
     " .fixtures.yml" +\
     " hiera.yaml" +\
     " data"
end

task :test => [:yamllint,:lint,:validate,:spec]
