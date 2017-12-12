module Fog
  module Compute
    class Google
      class Mock
        def insert_global_forwarding_rule(_rule_name, _opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        ##
        # Create a global forwarding rule.
        #
        # @see https://cloud.google.com/compute/docs/reference/latest/globalForwardingRules/insert
        def insert_global_forwarding_rule(rule_name, opts = {})
          opts = opts.merge(:name => rule_name)
          @compute.insert_global_forwarding_rule(
            @project, ::Google::Apis::ComputeV1::ForwardingRule.new(opts)
          )
        end
      end
    end
  end
end
