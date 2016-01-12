if Fog.credentials.keys.include? :google_storage_access_key_id
  require "fog/google/storage_xml"
else
  require "fog/google/storage_json"
end
