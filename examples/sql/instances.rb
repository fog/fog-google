def test
  connection = Fog::Google::SQL.new

  puts "Create a Instance..."
  puts "--------------------"
  instance = connection.instances.create(:name => Fog::Mock.random_letters(16), :tier => "D1")
  instance.wait_for { ready? }

  puts "Get the Instance..."
  puts "----------------------"
  connection.instances.get(instance.name)

  puts "List all Instances..."
  puts "---------------------"
  connection.instances.all

  puts "Update the Instance..."
  puts "----------------------"
  instance.settings[:activation_policy] = "ALWAYS"
  instance.update
  instance.wait_for { ready? }

  puts "Reset the Instance SSL configuration..."
  puts "---------------------------------------"
  instance.reset_ssl_config

  puts "Restart the Instance..."
  puts "-----------------------"
  instance.restart

  puts "Delete the Instance..."
  puts "----------------------"
  instance.destroy
end
