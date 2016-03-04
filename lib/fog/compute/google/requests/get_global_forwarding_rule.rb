module Fog
  module Compute
    class Google
      class Mock
        def get_global_forwarding_rule(name, _region_name = "global")
          global_forwarding_rule = data[:global_forwarding_rules][name]
          return nil if global_forwarding_rule.nil?
          build_excon_response(global_forwarding_rule)
        end
      end

      class Real
        def get_global_forwarding_rule(global_forwarding_rule_name, region_name = "global")
          if region_name.start_with? "http"
            region_name = region_name.split("/")[-1]
          end

          api_method = @compute.global_forwarding_rules.get
          parameters = {
            "project" => @project,
            "forwardingRule" => global_forwarding_rule_name,
            "region" => region_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
