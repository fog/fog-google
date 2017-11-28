module Fog
  module Compute
    class Google
      class Mock
        def delete_firewall(_firewall_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_firewall(firewall_name)
          @compute.delete_firewall(@project, firewall_name)
        end
      end
    end
  end
end
