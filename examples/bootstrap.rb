# All examples presume that you have a ~/.fog credentials file set up.
# More info on it can be found here: http://fog.io/about/getting_started.html

require "bundler"
Bundler.require(:default, :development)
# Uncomment this if you want to make real requests to GCE (you _will_ be billed!)
# WebMock.disable!

def test
  connection = Fog::Compute.new(:provider => "Google")

  server = connection.servers.bootstrap

  raise "Could not bootstrap sshable server." unless server.ssh("whoami")
  raise "Could not delete server." unless server.destroy
end

test
