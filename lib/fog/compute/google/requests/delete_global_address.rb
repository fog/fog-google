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
          @compute.delete_global_address(@project, address_name)
        end
      end
    end
  end
end
