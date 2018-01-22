module Fog
  module Storage
    class GoogleJSON
      class Directories < Fog::Collection
        model Fog::Storage::GoogleJSON::Directory

        def all(opts = {})
          data = service.list_buckets(opts).to_h[:items] || []
          load(data)
        end

        def get(bucket_name, options = {})
          if_metageneration_match = options[:if_metageneration_match]
          if_metageneration_not_match = options[:if_metageneration_not_match]
          projection = options[:projection]

          data = service.get_bucket(
            bucket_name,
            :if_metageneration_match => if_metageneration_match,
            :if_metageneration_not_match => if_metageneration_not_match,
            :projection => projection
          ).to_h

          new(data)
        rescue ::Google::Apis::ClientError => e
          # metageneration check failures returns HTTP 412 Precondition Failed
          raise e unless e.status_code == 404 || e.status_code == 412
          nil
        end
      end
    end
  end
end
