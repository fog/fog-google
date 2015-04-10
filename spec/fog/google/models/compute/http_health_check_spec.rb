require "minitest_helper"
require "helpers/collection_spec"

describe Fog::Compute[:google].http_health_checks do
  subject { Fog::Compute[:google].http_health_checks }

  def params
    {:name => test_name}
  end

  include Fog::CollectionSpec
end
