module Fog
  module Compute
    class Google
      class Mock
        def get_forwarding_rule(_rule, _region)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_forwarding_rule(rule, region)
          if region.start_with? "http"
            region = region.split("/")[-1]
          end
          @compute.get_forwarding_rule(@project, region, rule)
        end
      end
    end
  end
end
