module Fog
  module Google
    class Compute
      class Mock
        def delete_image(_image_name, _project = @project)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_image(image_name, project = @project)
          @compute.delete_image(project, image_name)
        end
      end
    end
  end
end
