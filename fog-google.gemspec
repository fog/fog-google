lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fog/google/version"

Gem::Specification.new do |spec|
  spec.name          = "fog-google"
  spec.version       = Fog::Google::VERSION
  spec.authors       = ["Nat Welch", "Artem Yakimenko"]
  spec.email         = ["nat@natwelch.com", "temikus@google.com"]
  spec.summary       = "Module for the 'fog' gem to support Google."
  spec.description   = "This library can be used as a module for `fog` or as standalone provider to use the Google Cloud in applications."
  spec.homepage      = "https://github.com/fog/fog-google"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # As of 0.1.1
  spec.required_ruby_version = ">= 2.0"

  # Locked until https://github.com/fog/fog-google/issues/417 is resolved
  spec.add_dependency "fog-core", "<= 2.1.0"
  spec.add_dependency "fog-json", "~> 1.2"
  spec.add_dependency "fog-xml", "~> 0.1.0"

  spec.add_dependency "google-api-client", ">= 0.44.2", "< 0.51"
  spec.add_dependency "google-cloud-env", "~> 1.2"

  # Debugger
  spec.add_development_dependency "pry"

  # Testing gems
  spec.add_development_dependency "retriable"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "shindo"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
