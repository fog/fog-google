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
TEST_REGION = "us-central1"
TEST_SIZE_GB = 10
TEST_MACHINE_TYPE = "n1-standard-1"

def create_test_name(base="resource", prefix="fog-test")
  [prefix, base] * "-"
end
