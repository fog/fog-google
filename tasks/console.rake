# From http://erniemiller.org/2014/02/05/7-lines-every-gems-rakefile-should-have/
# with some modification.

desc "Project IRB console"
task :console do
  require "bundler"
  Bundler.require(:default, :development)
  ARGV.clear
  Pry.start
end
