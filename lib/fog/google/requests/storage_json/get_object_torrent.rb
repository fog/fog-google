module Fog
  module Storage
    class GoogleJSON
      class Real
        # Get torrent for an Google Storage object
        # * Deprecated
        def get_object_torrent(_bucket_name, _object_name)
          Fog::Logger.deprecation("Fog::Storage::Google => ##{get_object_torrent} is deprecated.[/] [light_black](#{caller.first})")
        end
      end
    end
  end
end
