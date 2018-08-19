module Fog
  module Storage
    class GoogleJSON
      class Files < Fog::Collection
        model Fog::Storage::GoogleJSON::File

        extend Fog::Deprecation
        deprecate :get_url, :get_https_url

        attribute :common_prefixes, :aliases => "CommonPrefixes"
        attribute :delimiter,       :aliases => "Delimiter"
        attribute :directory
        attribute :page_token,      :aliases => %w(pageToken page_token)
        attribute :max_results,     :aliases => ["MaxKeys", "max-keys"]
        attribute :prefix,          :aliases => "Prefix"

        def all(options = {})
          requires :directory
          data = service.list_objects(directory.key, attributes.merge(options))
                        .to_h[:items] || []
          load(data)
        end

        alias_method :each_file_this_page, :each
        def each
          if block_given?
            subset = dup.all

            subset.each_file_this_page { |f| yield f }
          end
          self
        end

        def get(key, options = {}, &block)
          requires :directory
          data = service.get_object(directory.key, key, options, &block).to_h
          new(data)
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        def get_https_url(key, expires, options = {})
          requires :directory
          service.get_object_https_url(directory.key, key, expires, options)
        end

        def metadata(key, options = {})
          requires :directory
          data = service.get_object_metadata(directory.key, key, options).to_h
          new(data)
        rescue ::Google::Apis::ClientError
          nil
        end
        alias_method :head, :metadata

        def new(opts = {})
          requires :directory
          super({ :directory => directory }.merge(opts))
        end
      end
    end
  end
end
