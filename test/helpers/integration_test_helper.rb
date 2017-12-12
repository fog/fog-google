require "helpers/test_helper"
require "helpers/test_collection"

# Use :test credentials in ~/.fog for live integration testing
# XXX not sure if this will work on Travis CI or not
Fog.credential = :test

# Helpers

TEST_ZONE = "us-central1-f".freeze
TEST_REGION = "us-central1".freeze
TEST_SIZE_GB = 10
TEST_MACHINE_TYPE = "n1-standard-1".freeze
# XXX This depends on a public image in gs://fog-test-bucket; there may be a better way to do this
# The image was created like so: https://cloud.google.com/compute/docs/images#export_an_image_to_google_cloud_storage
TEST_RAW_DISK_SOURCE = "http://storage.googleapis.com/fog-test-bucket/fog-test-raw-disk-source.image.tar.gz".freeze

TEST_SQL_TIER_FIRST = "D1".freeze
TEST_SQL_REGION_FIRST = "us-central".freeze

TEST_SQL_TIER_SECOND = "db-f1-micro".freeze
TEST_SQL_REGION_SECOND = TEST_REGION

class FogIntegrationTest < MiniTest::Test
  def namespaced_name
    "#{self.class}_#{name}"
  end
end
