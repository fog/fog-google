module Fog
  module Storage
    class GoogleJSON
      class Directory < Fog::Model
        identity :key, :aliases => %w(Name name)

        def acl=(new_acl)
          valid_acls = %w(private projectPrivate publicRead publicReadWrite authenticatedRead)
          unless valid_acls.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{valid_acls.join(', ')}]")
          end
          @acl = new_acl
        end

        def destroy
          requires :key
          service.delete_bucket(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Storage::GoogleJSON::Files.new(
              :directory => self,
              :service => service
            )
          end
        end

        def public=(new_public)
          @acl = if new_public
                   "publicRead"
                 else
                   "private"
                 end
          new_public
        end

        def public_url
          requires :key
          acl = service.get_bucket_acl(key).body
          if acl["items"].detect { |entry| entry["entity"] == "allUsers" && entry["role"] == "READER" }
            if key.to_s =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
              "https://#{key}.storage.googleapis.com"
            else
              "https://storage.googleapis.com/#{key}"
            end
          end
        end

        def save
          requires :key
          options = {}
          options["predefinedAcl"] = @acl if @acl
          options["LocationConstraint"] = @location if @location
          options["StorageClass"] = attributes[:storage_class] if attributes[:storage_class]
          service.put_bucket(key, options)
          true
        end
      end
    end
  end
end
