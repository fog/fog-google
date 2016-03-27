# All examples presume that you have a ~/.fog credentials file set up.
# # More info on it can be found here: http://fog.io/about/getting_started.html
#
require "bundler"
Bundler.require(:default, :development)
# Uncomment this if you want to make real requests to GCE (you _will_ be billed!)
# WebMock.disable!

def test
  connection = Fog::Google::Monitoring.new

  puts "Listing all TimeseriesDescriptors for the metric compute.googleapis.com/instance/uptime..."
  puts "------------------------------------------------------------------------------------------"
  td = connection.timeseries_descriptors.all("compute.googleapis.com/instance/uptime",
                                             DateTime.now.rfc3339)
  puts "Number of matches: #{td.length}"

  puts "Listing all TimeseriesDescriptors for the metric compute.googleapis.com/instance/uptime &"
  puts "the region us-central1..."
  puts "-----------------------------------------------------------------------------------------"
  td = connection.timeseries_descriptors.all("compute.googleapis.com/instance/uptime",
                                             DateTime.now.rfc3339,
                                             :labels => "cloud.googleapis.com/location=~us-central1.*")
  puts "Number of matches: #{td.length}"
end

test
