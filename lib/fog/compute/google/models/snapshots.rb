module Fog
  module Compute
    class Google
      class Snapshots < Fog::Collection
        model Fog::Compute::Google::Snapshot

        def all
          items = []
          next_page_token = nil
          loop do
            data = service.list_snapshots(nil, next_page_token)
            items.concat(data.body["items"])
            next_page_token = data.body["nextPageToken"]
            break if next_page_token.nil? || next_page_token.empty?
          end
          load(items)
        end

        def get(snap_id)
          response = service.get_snapshot(snap_id)
          return nil if response.nil?
          new(response.body)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
