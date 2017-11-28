module Fog
  module Compute
    class Google
      class Mock
        def patch_firewall(_firewall_name, _firewall_opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        ##
        # Patch a Firewall resource. Supports PATCH semantics.
        #
        # @see https://cloud.google.com/compute/docs/reference/latest/firewalls/patch
        def patch_firewall(firewall_name, options = {})
          @compute.patch_firewall(
            @project, firewall_name,
            ::Google::Apis::ComputeV1::Firewall.new(
              options.select { |k, _| UPDATABLE_FIREWALL_FIELDS.include? k }
            )
          )
        end
      end
    end
  end
end
