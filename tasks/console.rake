# From http://erniemiller.org/2014/02/05/7-lines-every-gems-rakefile-should-have/
# with some modification.

desc 'Project IRB console'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'fog/google'
  Fog.credential = :test
  ARGV.clear
  IRB.start
end
