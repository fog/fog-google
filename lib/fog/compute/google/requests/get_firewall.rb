module Fog
  module Compute
    class Google
      class Mock
        def get_firewall(_firewall_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_firewall(firewall_name)
          @compute.get_firewall(@project, firewall_name)
        end
      end
    end
  end
end
