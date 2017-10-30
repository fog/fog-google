require "fog/core/model"

module Fog
  module Google
    class SQL
      ##
      # Represents a database user in a Cloud SQL instance.
      #
      # @see https://cloud.google.com/sql/docs/mysql/admin-api/v1beta4/users
      class User < Fog::Model
        attribute :name
        attribute :etag
        attribute :host
        attribute :instance
        attribute :kind
        attribute :project

        def destroy(async: true)
          requires :instance, :name, :host

          resp = service.delete_user(instance, host, name)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(resp.name)
          operation.wait_for { ready? } unless async
          operation
        end

        def save(password: nil)
          requires :instance, :name

          data = to_h
          data[:password] = password unless password.nil?
          service.insert_user(instance, data)
          self
        end
      end
    end
  end
end
