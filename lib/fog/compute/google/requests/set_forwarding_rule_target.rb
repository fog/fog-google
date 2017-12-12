module Fog
  module Compute
    class Google
      class Mock
        def set_forwarding_rule_target(_rule_name, _region, _target_opts)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_forwarding_rule_target(rule_name, region, target_opts)
          region = region.split("/")[-1] if region.start_with? "http"
          @compute.set_forwarding_rule_target(
            @project, region, rule_name,
            ::Google::Apis::ComputeV1::TargetReference.new(target_opts)
          )
        end
      end
    end
  end
end
