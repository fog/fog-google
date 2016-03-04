require 'fog'

def test
  connection = Fog::Google::Monitoring.new

  puts "Listing all MetricDescriptors..."
  puts "--------------------------------"
  md = connection.metric_descriptors
  puts "Number of all metric descriptors: #{md.length}"

  puts "\nListing all MetricDescriptors related to Google Compute Engine..."
  puts "-----------------------------------------------------------------"
  md = connection.metric_descriptors.all(:query => "compute")
  puts "Number of compute metric descriptors: #{md.length}"
end

test
