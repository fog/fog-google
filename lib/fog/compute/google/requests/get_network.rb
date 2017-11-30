module Fog
  module Compute
    class Google
      class Mock
        def get_network(_network_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_network(network_name)
          @compute.get_network(@project, network_name)
        end
      end
    end
  end
end
