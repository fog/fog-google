module Fog
  module Compute
    class Google
      class Mock
        def get_global_forwarding_rule(_rule)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_global_forwarding_rule(rule)
          @compute.get_global_forwarding_rule(@project, rule)
        end
      end
    end
  end
end
