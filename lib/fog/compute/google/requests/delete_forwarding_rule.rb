module Fog
  module Compute
    class Google
      class Mock
        def delete_forwarding_rule(_rule, _region)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_forwarding_rule(rule, region)
          region = region.split("/")[-1] if region.start_with? "http"
          @compute.delete_forwarding_rule(@project, region, rule)
        end
      end
    end
  end
end
