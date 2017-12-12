module Fog
  module Compute
    class Google
      class Mock
        def insert_forwarding_rule(_rule_name, _region, _opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        ##
        # Create a forwarding rule.
        #
        # @see https://cloud.google.com/compute/docs/reference/latest/forwardingRules/insert
        def insert_forwarding_rule(rule_name, region, opts = {})
          region = region.split("/")[-1] if region.start_with? "http"
          @compute.insert_forwarding_rule(
            @project, region,
            ::Google::Apis::ComputeV1::ForwardingRule.new(
              opts.merge(:name => rule_name)
            )
          )
        end
      end
    end
  end
end
