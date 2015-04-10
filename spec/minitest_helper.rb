require 'minitest/autorun'
require 'minitest/spec'
require 'securerandom'

if ENV['COVERAGE']
  require 'coveralls'
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
  end
end

require File.join(File.dirname(__FILE__), '../lib/fog/google.rb')

Coveralls.wear! if ENV['COVERAGE']

# Use :test credentials in ~/.fog for live integration testing
# XXX not sure if this will work on Travis CI or not
Fog.credential = :test

# Helpers

TEST_ZONE = "us-central1-a"
TEST_SOURCE_IMAGE = "debian-7-wheezy-v20140408"

def test_name(base, prefix="fog-test", suffix=SecureRandom.hex)
  [prefix, base, suffix] * "-"
end

# XXX this creates a disk, then doesn't delete it
def create_test_disk()
  disk = Fog::Compute[:google].disks.create({:name => test_name("disk"),
                                             :size_gb => "10",
                                             :zone => TEST_ZONE,
                                             :source_image => TEST_SOURCE_IMAGE})
  disk.wait_for { ready? }
  disk
end
