require 'securerandom'
Shindo.tests("Fog::Compute[:google] | backend service model", ['google']) do
  random_string = SecureRandom.hex
  @health_check = create_test_http_health_check(Fog::Compute[:google])
  model_tests(Fog::Compute[:google].backend_services, {:name => "fog-test-backend-service-#{random_string}",
      :health_checks => [@health_check.self_link]})
end
