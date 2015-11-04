# This example needs google_storage_access_key_id: and google_storage_secret_access_key to be set in ~/.fog
# One can request those keys via Google Developers console in:
# Storage -> Storage -> Settings -> "Interoperability" tab -> "Create a new key"

def test
  connection = Fog::Storage::Google.new

  puts "Put a bucket..."
  puts "----------------"
  connection.put_bucket("fog-smoke-test")

  puts "Get the bucket..."
  puts "-----------------"
  connection.get_bucket("fog-smoke-test")

  puts "Put a test file..."
  puts "---------------"
  connection.put_object("fog-smoke-test", "my file" ,"THISISATESTFILE")

  puts "Delete the test file..."
  puts "---------------"
  connection.delete_object("fog-smoke-test", "my file")

  puts "Delete the bucket..."
  puts "------------------"
  connection.delete_bucket("fog-smoke-test")
end
