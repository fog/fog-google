require "minitest_helper"
require "helpers/model_helper"

def http_health_check_param_generator
  Proc.new do
    {:name => test_name("http-health-check")}
  end
end

describe Fog::Compute[:google].http_health_checks do
  model_spec(Fog::Compute[:google].http_health_checks, http_health_check_param_generator)
end
