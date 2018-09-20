module Fog
  module Google
    class Compute
      class Mock
        def get_region(_identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_region(identity)
          @compute.get_region(@project, identity.split("/")[-1])
        end
      end
    end
  end
end
