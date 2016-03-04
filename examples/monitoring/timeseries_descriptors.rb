require 'fog'

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
