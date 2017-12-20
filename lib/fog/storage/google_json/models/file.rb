module Fog
  module Storage
    class GoogleJSON
      class File < Fog::Model
        identity :key, :aliases => ["Key", :name]

        attribute :acl
        attribute :predefined_acl,      :aliases => ["predefinedAcl", :predefined_acl]
        attribute :cache_control,       :aliases => ["cacheControl", :cache_control]
        attribute :content_disposition, :aliases => ["contentDisposition", :content_disposition]
        attribute :content_encoding,    :aliases => ["contentEncoding", :content_encoding]
        attribute :content_length,      :aliases => ["size", :size], :type => :integer
        attribute :content_md5,         :aliases => ["md5Hash", :md5_hash]
        attribute :content_type,        :aliases => ["contentType", :content_type]
        attribute :crc32c
        attribute :etag,                :aliases => ["etag", :etag]
        attribute :time_created,        :aliases => ["timeCreated", :time_created]
        attribute :last_modified,       :aliases => ["updated", :updated]
        attribute :generation
        attribute :metageneration
        attribute :metadata,            :aliases => ["metadata", :metadata]
        attribute :self_link,           :aliases => ["selfLink", :self_link]
        attribute :media_link,          :aliases => ["mediaLink", :media_link]
        attribute :owner
        attribute :storage_class, :aliases => "storageClass"

        # attribute :body

        def body
          last_modified && (file = collection.get(identity)) ? attributes[:body] ||= file.body : attributes[:body] ||= ""
        end

        def body=(new_body)
          attributes[:body] = new_body
        end

        attr_reader :directory

        def copy(target_directory_key, target_file_key, options = {})
          requires :directory, :key
          service.copy_object(directory.key, key, target_directory_key, target_file_key, options)
          target_directory = service.directories.new(:key => target_directory_key)
          target_directory.files.get(target_file_key)
        end

        def destroy
          requires :directory, :key
          service.delete_object(directory.key, key)
          true
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          false
        end

        def public_url
          requires :directory, :key
          "https://storage.googleapis.com/#{directory.key}/#{key}"
        end

        FILE_INSERTABLE_FIELDS = %i(
          content_type
          predefined_acl
          acl
          cache_control
          content_disposition
          content_encoding
          metadata
        ).freeze

        def save
          requires :body, :directory, :key

          options = Hash[
            FILE_INSERTABLE_FIELDS.map { |k| [k, attributes[k]] }
                                  .reject { |pair| pair[1].nil? }
          ]

          service.put_object(directory.key, key, body, options)
          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
          true
        end

        # params[:expires] : Eg: Time.now to integer value.
        def url(expires)
          requires :key
          collection.get_https_url(key, expires)
        end

        private

        attr_writer :directory
      end
    end
  end
end
