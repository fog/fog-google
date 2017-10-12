module Fog
  module Compute
    class Google
      class Mock
        def delete_global_address(_address_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_global_address(address_name)
          api_method = @compute.global_addresses.delete
          parameters = {
            "project" => @project,
            "address" => address_name,
          }
          request(api_method, parameters)
        end
      end
    end
  end
end
