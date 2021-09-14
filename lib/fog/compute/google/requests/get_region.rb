module Fog
  module Compute
    class Google
      class Mock
        def get_region(_identity)
          # :no-coverage:
          Fog::Mock.not_implemented
          # :no-coverage:
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
