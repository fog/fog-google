module Fog
  module Compute
    class Google
      class Mock
        def insert_global_address(_address_name, _options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_global_address(address_name, options = {})
          api_method = @compute.global_addresses.insert
          parameters = {
              "project" => @project
          }
          body_object = { "name" => address_name }
          body_object["description"] = options[:description] if options[:description]

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
