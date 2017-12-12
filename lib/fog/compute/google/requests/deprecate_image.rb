module Fog
  module Compute
    class Google
      class Mock
        def deprecate_image(_image_name, _deprecation_status = {}, _project = @project)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def deprecate_image(image_name, deprecation_status = {}, project = @project)
          @compute.deprecate_image(
            project, image_name,
            ::Google::Apis::ComputeV1::DeprecationStatus.new(deprecation_status)
          )
        end
      end
    end
  end
end
