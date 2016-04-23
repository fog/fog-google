require "fog/core/model"

module Fog
  module Google
    class SQL
      ##
      # An Operation resource contains information about database instance operations
      # such as create, delete, and restart
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/operations
      class Operation < Fog::Model
        identity :operation

        attribute :end_time, :aliases => "endTime"
        attribute :enqueued_time, :aliases => "enqueuedTime"
        attribute :error
        attribute :export_context, :aliases => "exportContext"
        attribute :import_context, :aliases => "importContext"
        attribute :instance
        attribute :kind
        attribute :operation_type, :aliases => "operationType"
        attribute :start_time, :aliases => "startTime"
        attribute :state
        attribute :user_email_address, :aliases => "userEmailAddress"

        DONE_STATE    = "DONE".freeze
        PENDING_STATE = "PENDING".freeze
        RUNNING_STATE = "RUNNING".freeze
        UNKNOWN_STATE = "UNKNOWN".freeze

        ##
        # Checks if the instance operation is pending
        #
        # @return [Boolean] True if the operation is pending; False otherwise
        def pending?
          state == PENDING_STATE
        end

        ##
        # Checks if the instance operation is done
        #
        # @return [Boolean] True if the operation is done; False otherwise
        def ready?
          state == DONE_STATE
        end

        ##
        # Reloads an instance operation
        #
        # @return [Fog::Google::SQL::Operation] Instance operation resource
        def reload
          requires :identity

          data = collection.get(instance, identity)
          merge_attributes(data.attributes)
          self
        end
      end
    end
  end
end
