module Fog
  module Compute
    class Google
      class Mock
        def delete_network(_network_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_network(network_name)
          @compute.delete_network(@project, network_name)
        end
      end
    end
  end
end
