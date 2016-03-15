require "fog"

def test
  connection = Fog::Google::Monitoring.new

  puts "Listing all Timeseries for the metric compute.googleapis.com/instance/uptime..."
  puts "-------------------------------------------------------------------------------"
  tc = connection.timeseries_collection.all("compute.googleapis.com/instance/uptime",
                                            DateTime.now.rfc3339)
  puts "Number of matches: #{tc.length}"

  puts "\nListing all Timeseries for the metric compute.googleapis.com/instance/uptime &"
  puts "the region us-central1..."
  puts "------------------------------------------------------------------------------"
  tc = connection.timeseries_collection.all("compute.googleapis.com/instance/uptime",
                                            DateTime.now.rfc3339,
                                            :labels => "cloud.googleapis.com/location=~us-central1.*")
  puts "Number of matches: #{tc.length}"
end

test
