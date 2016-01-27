require "fog/core/model"

module Fog
  module Storage
    class GoogleJSON
      class File < Fog::Model
        identity :key, :aliases => "Key"

        # TODO: Verify
        attribute :acl
        attribute :predefined_acl
        attribute :cache_control,       :aliases => "cacheControl"
        attribute :content_disposition, :aliases => "contentDisposition"
        attribute :content_encoding,    :aliases => "contentEncoding"
        attribute :content_length,      :aliases => "size", :type => :integer
        attribute :content_md5,         :aliases => "md5Hash"
        attribute :content_type,        :aliases => "contentType"
        attribute :crc32c
        attribute :etag,                :aliases => "etag"
        attribute :time_created,        :aliases => "timeCreated"
        attribute :last_modified,       :aliases => "updated"
        attribute :generation
        attribute :metageneration
        attribute :metadata
        attribute :self_link,           :aliases => "selfLink"
        attribute :media_link,          :aliases => "mediaLink"
        attribute :owner
        attribute :storage_class, :aliases => "storageClass"

        @valid_predefined_acls = %w(private projectPrivate bucketOwnerFullControl bucketOwnerRead authenticatedRead publicRead)

        def predefined_acl=(new_acl)
          unless @valid_predefined_acls.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{@valid_predefined_acls.join(', ')}]")
          end
          @predefined_acl = new_acl
        end

        # TODO: Implement object ACLs
        # def acl=(new_acl)
        #   valid_acls = ["private", "projectPrivate", "bucketOwnerFullControl", "bucketOwnerRead", "authenticatedRead", "publicRead"]
        #   unless valid_acls.include?(new_acl)
        #     raise ArgumentError.new("acl must be one of [#{valid_acls.join(', ')}]")
        #   end
        #   @acl = new_acl
        # end

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
          service.delete_object(directory.key, key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        # TODO: Verify
        remove_method :metadata=
        def metadata=(new_metadata)
          metadata.merge!(new_metadata)
        end

        # TODO: Verify
        remove_method :owner=
        def owner=(new_owner)
          if new_owner
            attributes[:owner] = {
              :entity => new_owner["entity"],
              :entityId  => new_owner["entityId"]
            }
          end
        end

        # TODO: Verify
        def public=(new_public)
          if new_public
            @predefined_acl = "publicRead"
          else
            @predefined_acl = "private"
          end
          new_public
        end

        # TODO: Verify
        def public_url
          requires :directory, :key

          acl = service.get_object_acl(directory.key, key).body
          access_granted = acl["items"].detect { |entry| entry["entity"] == "allUsers" && entry["role"] == "READER" }

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
          options["contentType"] = content_type if content_type
          options["predefinedAcl"] ||= @predefined_acl if @predefined_acl # predefinedAcl may need to be in parameters
          options["acl"] ||= @acl if @acl # Not sure if you can provide both acl and predefinedAcl
          options["cacheControl"] = cache_control if cache_control
          options["contentDisposition"] = content_disposition if content_disposition
          options["contentEncoding"] = content_encoding if content_encoding
          options["md5Hash"] = content_md5 if content_md5
          options["crc32c"] = crc32c if crc32c
          options["metadata"] = metadata

          data = service.put_object(directory.key, key, body, options)
          merge_attributes(data.headers.reject { |key, _value| %w(contentLength contentType).include?(key) })
          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
          true
        end

        def url
          requires :key
          collection.get_https_url(key)
        end

        private

        attr_writer :directory
      end
    end
  end
end
