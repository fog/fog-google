module Fog
  module Storage
    class GoogleXML
      class Real
        # Get an expiring object url from Google Storage
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object
        # * object_name<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object

        def get_object_url(bucket_name, object_name, expires)
          Fog::Logger.deprecation("Fog::Storage::Google => #get_object_url is deprecated, use #get_object_https_url instead[/] [light_black](#{caller(1..1).first})")
          get_object_https_url(bucket_name, object_name, expires)
        end
      end

      class Mock # :nodoc:all
        def get_object_url(bucket_name, object_name, expires)
          Fog::Logger.deprecation("Fog::Storage::Google => #get_object_url is deprecated, use #get_object_https_url instead[/] [light_black](#{caller(1..1).first})")
          get_object_https_url(bucket_name, object_name, expires)
        end
      end
    end
  end
end
