module Fog
  module Storage
    class GoogleJSON
      class Real
        # Get an expiring object url from GCS
        # Deprecated, redirects to get_object_https_url.rb
        def get_object_url(bucket_name, object_name, expires, options = {})
          Fog::Logger.deprecation("Fog::Storage::Google => #get_object_url is deprecated, use #get_object_https_url instead[/] [light_black](#{caller(0..0)})")
          # **options.transform_keys(&:to_sym) is needed so paperclip doesn't break on Ruby 2.6
          # TODO(temikus): remove this once Ruby 2.6 is deprecated for good
          get_object_https_url(bucket_name, object_name, expires, **options.transform_keys(&:to_sym))
        end
      end

      class Mock # :nodoc:all
        def get_object_url(bucket_name, object_name, expires, options = {})
          Fog::Logger.deprecation("Fog::Storage::Google => #get_object_url is deprecated, use #get_object_https_url instead[/] [light_black](#{caller(0..0)})")
          # **options.transform_keys(&:to_sym) is needed so paperclip doesn't break on Ruby 2.6
          # TODO(temikus): remove this once Ruby 2.6 is deprecated for good
          get_object_https_url(bucket_name, object_name, expires, **options.transform_keys(&:to_sym))
        end
      end
    end
  end
end
