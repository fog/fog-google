if Fog.credentials.keys.include? :google_client_email 
  require "fog/google/storage_json"
else
  require "fog/google/storage_xml"
end