module Fog
  module Storage
    class GoogleJSON
      class Real
        # Delete an object from Google Storage
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object to delete
        # * object_name<~String> - Name of object to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 204
        def delete_object(bucket_name, object_name)
          api_method = @storage_json.objects.delete
          parameters = {
            "bucket" => bucket_name,
            "object" => object_name
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def delete_object(bucket_name, object_name)
          response = Excon::Response.new
          if bucket = data[:buckets][bucket_name]
            if object = bucket[:objects][object_name]
              response.status = 204
              bucket[:objects].delete(object_name)
            else
              response.status = 404
              raise(Excon::Errors.status_error({ :expects => 204 }, response))
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error({ :expects => 204 }, response))
          end
          response
        end
      end
    end
  end
end
