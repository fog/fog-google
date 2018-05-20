# All examples presume that you have a ~/.fog credentials file set up.
# More info on it can be found here: http://fog.io/about/getting_started.html

require "bundler"
Bundler.require(:default, :development)
# Uncomment this if you want to make real requests to GCE (you _will_ be billed!)
# WebMock.disable!

def test
  connection = Fog::Compute.new(:provider => "Google")

  disk = connection.disks.create(
    :name => "fog-smoke-test-#{Time.now.to_i}",
    :size_gb => 10,
    :zone => "us-central1-f",
    :source_image => "debian-8-jessie-v20180329"
  )

  disk.wait_for { disk.ready? }

  server = connection.servers.create(
    :name => "fog-smoke-test-#{Time.now.to_i}",
    :disks => [disk],
    :machine_type => "n1-standard-1",
    :private_key_path => File.expand_path("~/.ssh/id_rsa"),
    :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
    :zone => "us-central1-f",
    :username => ENV["USER"],
    :tags => ["fog"],
    :service_accounts => { :scopes => %w(sql-admin bigquery https://www.googleapis.com/auth/compute) }
  )

  # Wait_for routine copied here to show errors, if necessary.
  duration = 0
  interval = 5
  timeout = 600
  start = Time.now
  until server.sshable? || duration > timeout
    # puts duration
    # puts " ----- "

    server.reload

    # p "ready?: #{server.ready?}"
    # p "public_ip_address: #{server.public_ip_address.inspect}"
    # p "public_key: #{server.public_key.inspect}"
    # p "metadata: #{server.metadata.inspect}"
    # p "sshable?: #{server.sshable?}"

    sleep(interval.to_f)
    duration = Time.now - start
  end

  raise "Could not bootstrap sshable server." unless server.ssh("whoami")
  raise "Could not delete server." unless server.destroy
end

test
