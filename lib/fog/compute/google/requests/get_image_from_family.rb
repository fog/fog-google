module Fog
  module Compute
    class Google
      # Returns the latest non-deprecated image that is part of an image family.
      #
      # ==== Parameters
      # * family<~String> - Name of the image resource to return.
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash> - corresponding compute#image resource
      #
      # ==== See also:
      # https://cloud.google.com/compute/docs/reference/latest/images/getFromFamily
      class Mock
        def get_image_from_family(_family, _project = @project)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_image_from_family(family, project = nil)
          api_method = @compute.images.get_from_family
          project = @project if project.nil?
          parameters = {
            "family" => family,
            "project" => project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
