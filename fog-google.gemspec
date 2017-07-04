# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fog/google/version"

Gem::Specification.new do |spec|
  spec.name          = "fog-google"
  spec.version       = Fog::Google::VERSION
  spec.authors       = ["Nat Welch", "Daniel Broudy", "Isaac Hollander McCreery", "Dean Putney"]
  spec.email         = ["nat@natwelch.com", "broudy@google.com", "ihmccreery@google.com", "dean@glowforge.com"]
  spec.summary       = "Module for the 'fog' gem to support Google."
  spec.description   = 'This library can be used as a module for `fog` or as standalone provider
                        to use the Google in applications.'
  spec.homepage      = "https://github.com/fog/fog-google"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # As of 0.1.1
  spec.required_ruby_version = "~> 2.0"

  spec.add_dependency "fog-core"
  spec.add_dependency "fog-json"
  spec.add_dependency "fog-xml"

  # Needed for Ruby < 2.3 which doesn't support squiggly
  spec.add_dependency "unindent"

  # TODO: Upgrade to 0.9, which is not compatible.
  spec.add_development_dependency "google-api-client", "~> 0.8.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "shindo"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "mime-types"
end
