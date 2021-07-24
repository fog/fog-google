# Configure simplecov for coverage tests
# Note: needs to be done _before_ requiring minitest!
if ENV["COVERAGE"]
  require "simplecov"

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  SimpleCov.skip_token('no-coverage')

  SimpleCov.start do
    add_filter "/test/"
  end
end

# The next line was added to squelch a warning message in Ruby 1.9.
# It ensures we're using the gem, not the built-in Minitest
# See https://github.com/seattlerb/minitest/#install
gem "minitest"
require "minitest/autorun"

# This is a workaround for RubyMine debugger that doesn't play nice with Minitest::Reporters
unless ENV['RM_INFO']
  # Custom formatters to make the tests more legible in CI
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end

require File.join(File.dirname(__FILE__), "../../lib/fog/google")
