require "minitest_helper"
require "helpers/collection_spec"

describe Fog::Compute[:google].disks do
  subject { Fog::Compute[:google].disks }

  def params
    {:name => test_name,
     :zone_name => TEST_ZONE,
     :size_gb => TEST_SIZE_GB}
  end

  include Fog::CollectionSpec
end
