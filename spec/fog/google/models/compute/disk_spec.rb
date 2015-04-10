require "minitest_helper"
require "helpers/model_helper"

def disk_param_generator
  Proc.new do
    {:name => test_name("disk"),
     :zone_name => TEST_ZONE,
     :size_gb => TEST_SIZE_GB}
  end
end

describe Fog::Compute[:google].disks do
  model_spec(Fog::Compute[:google].disks, disk_param_generator)
end
