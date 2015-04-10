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
TEST_SIZE_GB = 10
TEST_MACHINE_TYPE = "n1-standard-1"

def test_name(base="resource", prefix="fog-test", suffix=SecureRandom.hex)
  [prefix, base, suffix] * "-"
end

# XXX this creates a disk, then doesn't delete it
def create_test_disk()
  disk = Fog::Compute[:google].disks.create({:name => test_name,
                                             :size_gb => TEST_SIZE_GB,
                                             :zone => TEST_ZONE,
                                             :source_image => TEST_SOURCE_IMAGE})
  disk.wait_for { ready? }
  disk
end
