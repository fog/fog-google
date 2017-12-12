module Fog
  module Google
    class Monitoring
      class Real
        def delete_metric_descriptor(metric_type)
          @monitoring.delete_project_metric_descriptor("projects/#{@project}/metricDescriptors/#{metric_type}")
        end
      end

      class Mock
        def delete_metric_descriptor(_metric_type)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
