module Fog
  module Compute
    class Google
      class Mock
        def delete_global_forwarding_rule(_rule)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_global_forwarding_rule(rule)
          @compute.delete_global_forwarding_rule(@project, rule)
        end
      end
    end
  end
end
