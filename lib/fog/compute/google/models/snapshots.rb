module Fog
  module Compute
    class Google
      class Snapshots < Fog::Collection
        model Fog::Compute::Google::Snapshot

        def all
          items = []
          next_page_token = nil
          loop do
            data = service.list_snapshots(:page_token => next_page_token)
            next_items = data.to_h[:items] || []
            items.concat(next_items)
            next_page_token = data.next_page_token
            break if next_page_token.nil? || next_page_token.empty?
          end
          load(items)
        end

        def get(snap_id)
          response = service.get_snapshot(snap_id)
          return nil if response.nil?
          new(response.to_h)
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
