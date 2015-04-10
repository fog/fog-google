# TODO REMOVE this testing functionality is now covered in `spec/fog/google/models/compute/http_health_check_spec.rb`

require 'securerandom'
Shindo.tests("Fog::Compute[:google] | HTTP health check model", ['google']) do
  random_string = SecureRandom.hex
  model_tests(Fog::Compute[:google].http_health_checks, {:name => "fog-test-http-health-check-#{random_string}"})
end
