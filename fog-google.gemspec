# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/google/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-google"
  spec.version       = Fog::GOOGLE::VERSION
  spec.authors       = ["Daniel Broudy"]
  spec.email         = ["broudy@google.com"]
  spec.summary       = %q{Module for the 'fog' gem to support Google Cloud Platform.}
  spec.description   = %q{This library can be used as a module for `fog` or as standalone provider
                        to use the Google Cloud Platform in applications..}
  spec.homepage      = "http://github.com/fog/fog-google"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  ## Dependencies only needed for development
  #spec.add_development_dependency 'minitest'
  #spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'shindo',  '~> 0.3'
   spec.add_development_dependency 'yard',  '~> 0.3'
  #spec.add_development_dependency 'thor'
  spec.add_development_dependency 'google-api-client',  '~> 0.6', '>=0.6.2'
  #spec.add_development_dependency ('rubocop') if RUBY_VERSION > "1.9"
  

  ## Runtime dependencies.
  spec.add_dependency 'fog-core',  '~> 1.27'
  spec.add_dependency 'fog-json',  '~> 1.0'
  spec.add_dependency 'fog-xml',   '~> 0.1'
#  spec.add_dependency 'ipaddress', '~> 0.8'
#  spec.add_dependency 'nokogiri', '>1.5.11'
end
