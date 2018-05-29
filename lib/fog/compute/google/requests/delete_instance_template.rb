module Fog
  module Compute
    class Google
      class Mock
        def delete_instance_template(_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_instance_template(name)
          @compute.delete_instance_template(@project, name)
        end
      end
    end
  end
end
