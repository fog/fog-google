require File.expand_path('../../lib/fog/google', __FILE__)

Bundler.require(:test)

Excon.defaults.merge!(:debug_request => true, :debug_response => true)

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'mock_helper'))

# This overrides the default 600 seconds timeout during live test runs
if Fog.mocking?
  FOG_TESTING_TIMEOUT = ENV['FOG_TEST_TIMEOUT'] || 2000
  Fog.timeout = 2000
  Fog::Logger.warning "Setting default fog timeout to #{Fog.timeout} seconds"
else
  FOG_TESTING_TIMEOUT = Fog.timeout
end

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

def array_differences(array_a, array_b)
  (array_a - array_b) | (array_b - array_a)
end

# mark libvirt tests pending if not setup
#begin
#  require('libvirt')
#rescue LoadError
#  Fog::Formatador.display_line("[yellow]Skipping tests for [bold]libvirt[/] [yellow]due to missing `ruby-libvirt` gem.[/]")
#  Thread.current[:tags] << '-libvirt'
#end
