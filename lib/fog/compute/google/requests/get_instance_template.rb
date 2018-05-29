module Fog
  module Compute
    class Google
      class Mock
        def get_instance_template(_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_instance_template(name)
          @compute.get_instance_template(@project, name)
        end
      end
    end
  end
end
