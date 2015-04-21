require 'securerandom'
Shindo.tests("Fog::Compute[:google] | images model", ['google']) do
  random_string = SecureRandom.hex
  source = 'http://storage.googleapis.com/fog-test-bucket/fog-test-raw-disk-source.image.tar.gz'
  collection_tests(Fog::Compute[:google].images, {:name => "fog-test-images-#{random_string}", "rawDisk" => { "source" => source } })
end
