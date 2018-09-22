module Fog
  module Storage
    class GoogleJSON
      class Real
        # Get an expiring object url from GCS
        # Deprecated, redirects to get_object_https_url.rb
        def get_object_url(bucket_name, object_name, expires, options = {})
          Fog::Logger.deprecation("Fog::Storage::Google => #get_object_url is deprecated, use #get_object_https_url instead[/] [light_black](#{caller(0..0)})")
          get_object_https_url(bucket_name, object_name, expires, options)
        end
      end

      class Mock # :nodoc:all
        def get_object_url(bucket_name, object_name, expires, options = {})
          Fog::Logger.deprecation("Fog::Storage::Google => #get_object_url is deprecated, use #get_object_https_url instead[/] [light_black](#{caller(0..0)})")
          get_object_https_url(bucket_name, object_name, expires, options)
        end
      end
    end
  end
end
