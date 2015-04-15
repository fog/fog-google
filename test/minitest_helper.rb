require 'minitest/autorun'
require 'vcr'

if ENV['COVERAGE']
  require 'coveralls'
  require 'simplecov'

  SimpleCov.start do
    add_filter '/test/'
  end
end

require File.join(File.dirname(__FILE__), '../lib/fog/google.rb')

Coveralls.wear! if ENV['COVERAGE']

VCR.configure do |c|
  c.cassette_library_dir = "test/cassettes"
  c.hook_into :webmock
end

# Use :test credentials in ~/.fog for live integration testing
# XXX not sure if this will work on Travis CI or not
Fog.credential = :test

# Helpers

TEST_ZONE = "us-central1-a"
TEST_SOURCE_IMAGE = "debian-7-wheezy-v20140408"
TEST_SIZE_GB = 10
TEST_MACHINE_TYPE = "n1-standard-1"

def create_test_name(base="resource", prefix="fog-test")
  [prefix, base] * "-"
end

# XXX this creates a disk, then doesn't delete it
def create_test_disk()
  disk = Fog::Compute[:google].disks.create({:name => create_test_name,
                                             :size_gb => TEST_SIZE_GB,
                                             :zone => TEST_ZONE,
                                             :source_image => TEST_SOURCE_IMAGE})
  disk.wait_for { ready? }
  disk
end
