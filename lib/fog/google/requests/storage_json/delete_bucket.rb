module Fog
  module Storage
    class GoogleJSON
      class Real
        # Delete an Google Storage bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 204
        def delete_bucket(bucket_name)
          api_method = @storage_json.buckets.delete
          parameters = {
            "bucket" => bucket_name
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def delete_bucket(bucket_name)
          response = Excon::Response.new
          if data[:buckets][bucket_name].nil?
            response.status = 404
            raise(Excon::Errors.status_error({ :expects => 204 }, response))
          elsif data[:buckets][bucket_name] && !data[:buckets][bucket_name][:objects].empty?
            response.status = 409
            raise(Excon::Errors.status_error({ :expects => 204 }, response))
          else
            data[:buckets].delete(bucket_name)
            response.status = 204
          end
          response
        end
      end
    end
  end
end
