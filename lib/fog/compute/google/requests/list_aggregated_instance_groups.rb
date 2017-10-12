module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_instance_groups(_options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_aggregated_instance_groups(options = {})
          @compute.list_aggregated_instance_groups(@project,
                                                   :filter => options[:filter])
        end
      end
    end
  end
end
