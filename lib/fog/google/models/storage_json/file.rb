require "fog/core/model"

module Fog
  module Google
    class StorageJSON
      class File < Fog::Model
        identity :key, :aliases => "Key"

        # TODO: Verify
        attribute :cache_control,       :aliases => "Cache-Control"
        attribute :content_disposition, :aliases => "Content-Disposition"
        attribute :content_encoding,    :aliases => "Content-Encoding"
        attribute :content_length,      :aliases => ["Content-Length", "Size"], :type => :integer
        attribute :content_md5,         :aliases => "Content-MD5"
        attribute :content_type,        :aliases => "Content-Type"
        attribute :etag,                :aliases => %w(Etag ETag)
        attribute :expires,             :aliases => "Expires"
        attribute :last_modified,       :aliases => ["Last-Modified", "LastModified"]
        attribute :metadata
        attribute :owner,               :aliases => "Owner"
        attribute :storage_class,       :aliases => ["x-goog-storage-class", "StorageClass"]

        # TODO: Verify
        def acl=(new_acl)
          valid_acls = ["private", "projectPrivate", "bucketOwnerFullControl", "bucketOwnerRead", "authenticatedRead", "publicRead"]
          unless valid_acls.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{valid_acls.join(', ')}]")
          end
          @acl = new_acl
        end

        # TODO: Verify
        def body
          attributes[:body] ||= last_modified && (file = collection.get(identity)) ? file.body : ""
        end

        # TODO: Verify
        def body=(new_body)
          attributes[:body] = new_body
        end

        attr_reader :directory

        # TODO: Verify
        def copy(target_directory_key, target_file_key)
          requires :directory, :key
          service.copy_object(directory.key, key, target_directory_key, target_file_key)
          target_directory = service.directories.new(:key => target_directory_key)
          target_directory.files.get(target_file_key)
        end

        # TODO: Verify
        def destroy
          requires :directory, :key
          begin
            service.delete_object(directory.key, key)
          rescue Excon::Errors::NotFound
          end
          true
        end

        # TODO: Verify
        remove_method :metadata
        def metadata
          attributes.reject { |key, _value| !(key.to_s =~ /^x-goog-meta-/) }
        end

        # TODO: Verify
        remove_method :metadata=
        def metadata=(new_metadata)
          merge_attributes(new_metadata)
        end

        # TODO: Verify
        remove_method :owner=
        def owner=(new_owner)
          if new_owner
            attributes[:owner] = {
              :display_name => new_owner["DisplayName"],
              :id           => new_owner["ID"]
            }
          end
        end

        # TODO: Verify
        def public=(new_public)
          if new_public
            @acl = "publicRead"
          else
            @acl = "private"
          end
          new_public
        end

        # TODO: Verify
        def public_url
          requires :directory, :key

          acl = service.get_object_acl(directory.key, key).body["AccessControlList"]
          access_granted = acl.detect do |entry|
            entry["Scope"]["type"] == "AllUsers" && entry["Permission"] == "READ"
          end

          if access_granted
            if directory.key.to_s =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
              "https://#{directory.key}.storage.googleapis.com/#{key}"
            else
              "https://storage.googleapis.com/#{directory.key}/#{key}"
            end
          end
        end

        # TODO: Verify
        def save(options = {})
          requires :body, :directory, :key
          if options != {}
            Fog::Logger.deprecation("options param is deprecated, use acl= instead [light_black](#{caller.first})[/]")
          end
          options["predefinedAcl"] ||= @acl if @acl
          options["Cache-Control"] = cache_control if cache_control
          options["Content-Disposition"] = content_disposition if content_disposition
          options["Content-Encoding"] = content_encoding if content_encoding
          options["Content-MD5"] = content_md5 if content_md5
          options["Content-Type"] = content_type if content_type
          options["Expires"] = expires if expires
          options.merge!(metadata)

          data = service.put_object(directory.key, key, body, options)
          merge_attributes(data.headers.reject { |key, _value| ["Content-Length", "Content-Type"].include?(key) })
          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
          true
        end

        def url(expires)
          requires :key
          collection.get_http_url(key, expires)
        end

        private

        attr_writer :directory
      end
    end
  end
end
