module Fog
  module Compute
    class Google
      class Mock
        def set_global_forwarding_rule_target(_rule_name, _target)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_global_forwarding_rule_target(rule_name, target_opts)
          @compute.set_global_forwarding_rule_target(
            @project, rule_name,
            ::Google::Apis::ComputeV1::TargetReference.new(target_opts)
          )
        end
      end
    end
  end
end
