require "fog/core/model"

module Fog
  module Google
    class SQL
      class Instance < Fog::Model
        identity :name

        attribute :current_disk_size, :aliases => "currentDiskSize"
        attribute :database_version, :aliases => "databaseVersion"
        attribute :etag
        attribute :ip_addresses, :aliases => "ipAddresses"
        attribute :kind
        attribute :max_disk_size, :aliases => "maxDiskSize"
        attribute :project
        attribute :region
        attribute :server_ca_cert, :aliases => "serverCaCert"
        attribute :settings
        attribute :state

        # These attributes are not available in the representation of an 'Instance' returned by the Google SQL API.
        attribute :activation_policy
        attribute :authorized_gae_applications
        attribute :backup_configuration
        attribute :database_flags
        attribute :ip_configuration_authorized_networks
        attribute :ip_configuration_enabled
        attribute :ip_configuration_require_ssl
        attribute :location_preference_zone_follow_gae_application
        attribute :location_preference_zone
        attribute :pricing_plan
        attribute :replication_type
        attribute :settings_version
        attribute :tier

        MAINTENANCE_STATE    = "MAINTENANCE".freeze
        PENDING_CREATE_STATE = "PENDING_CREATE".freeze
        RUNNABLE_STATE       = "RUNNABLE".freeze
        SUSPENDED_STATE      = "SUSPENDED".freeze
        UNKNOWN_STATE        = "UNKNOWN_STATE".freeze

        ##
        # Returns the activation policy for this instance
        #
        # @return [String] The activation policy for this instance
        def activation_policy
          settings[:activation_policy]
        end

        ##
        # Returns the AppEngine app ids that can access this instance
        #
        # @return [Array<String>] The AppEngine app ids that can access this instance
        def authorized_gae_applications
          settings[:authorized_gae_applications]
        end

        ##
        # Returns the daily backup configuration for the instance
        #
        # @return [Hash] The daily backup configuration for the instance
        def backup_configuration
          settings["backup_configuration"]
        end

        ##
        # Creates a Cloud SQL instance as a clone of the source instance
        #
        # @param [String] destination_name Name of the Cloud SQL instance to be created as a clone
        # @param [Boolean] async If the operation must be performed asynchronously (true by default)
        # @param [String] log_filename Name of the binary log file for a Cloud SQL instance
        # @param [Integer] log_position Position (offset) within the binary log file
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def clone(destination_name, async: true, log_filename: nil, log_position: nil)
          requires :identity

          data = service.clone_instance(
            identity, destination_name,
            :log_filename => log_filename,
            :log_position => log_position
          )
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.tap { |o| o.wait_for { ready? } unless async }
        end

        ##
        # Creates a Cloud SQL instance
        # @param [Boolean] async If the operation must be performed asynchronously
        #
        #   This is true by default since SQL instances return Google::Apis::ClientError: invalidState
        #   whenever an instance is in a transition process (creation, deletion, etc.) which makes it
        #   hard to operate unless one puts guard clauses on Google::Apis::ClientError everywhere.
        #
        #   TODO: Rethink this when API graduates out of beta. (Written as of V1beta4)
        #
        # @return [Fog::Google::SQL::Instance] Instance resource
        def create(async = false)
          requires :identity

          data = service.insert_instance(identity, attributes[:tier], attributes)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.wait_for { ready? } unless async
          reload
        end

        ##
        # Returns the database flags passed to the instance at startup
        #
        # @return [Array<Hash>] The database flags passed to the instance at startup
        def database_flags
          settings[:database_flags]
        end

        ##
        # Deletes a Cloud SQL instance
        #
        # @param [Boolean] async If the operation must be performed asynchronously (false by default)
        #   See Fog::Google::SQL::Instance.create on details why default is set this way.
        #
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def destroy(async = false)
          requires :identity

          data = service.delete_instance(identity)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.tap { |o| o.wait_for { ready? } unless async }
        end

        ##
        # Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file
        #
        # @param [String] uri The path to the file in Google Cloud Storage where the export will be stored,
        #   or where it was already stored
        # @param [Hash] options Method options
        # @option options [Array<String>] :databases Databases (for example, guestbook) from which the export is made.
        #   If unspecified, all databases are exported.
        # @option options [Array<String>] :tables Tables to export, or that were exported, from the specified database.
        #   If you specify tables, specify one and only one database.
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def export(uri, options: {})
          requires :identity

          data = service.export_instance(identity, uri, options)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.tap { |o| o.wait_for { ready? } unless async }
        end

        ##
        # Imports data into a Cloud SQL instance from a MySQL dump file in Google Cloud Storage
        #
        # @param [Array<String>] uri A path to the MySQL dump file in Google Cloud Storage from which the import is
        #   made
        # @param [Hash] options Method options
        # @option options [String] :database The database (for example, guestbook) to which the import is made.
        #   If not set, it is assumed that the database is specified in the file to be imported.
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def import(uri, options = {})
          requires :identity

          data = service.import_instance(identity, uri, options)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.tap { |o| o.wait_for { ready? } unless options.fetch(:async, true) }
        end

        ##
        # Returns the list of external networks that are allowed to connect to the instance using the IP
        #
        # @return [Array<String>] The list of external networks that are allowed to connect to the instance using the IP
        def ip_configuration_authorized_networks
          settings.fetch(:ip_configuration, {})
                  .fetch(:authorized_networks, [])
        end

        ##
        # Returns whether the instance should be assigned an IP address or not
        #
        # @return [Boolean] Whether the instance should be assigned an IP address or not
        def ip_configuration_ipv4_enabled
          settings.fetch(:ip_configuration, {})[:ipv4_enabled]
        end

        ##
        # Returns whether SSL connections over IP should be enforced or not.
        #
        # @return [Boolean] Whether SSL connections over IP should be enforced or not.
        def ip_configuration_require_ssl
          settings.fetch(:ip_configuration, {})[:require_ssl]
        end

        ##
        # Returns the AppEngine application to follow
        #
        # @return [String] The AppEngine application to follow
        def location_preference_zone_follow_gae_application
          settings.fetch(:location_preference, {})[:follow_gae_application]
        end

        ##
        # Returns the preferred Compute Engine zone
        #
        # @return [String] The preferred Compute Engine zone
        def location_preference_zone
          settings.fetch(:location_preference, {})[:zone]
        end

        ##
        # Returns the pricing plan for this instance
        #
        # @return [String] The pricing plan for this instance
        def pricing_plan
          settings[:pricing_plan]
        end

        ##
        # Checks if the instance is running
        #
        # @return [Boolean] True if the instance is running; False otherwise
        def ready?
          state == RUNNABLE_STATE
        end

        ##
        # Returns the type of replication this instance uses
        #
        # @return [String] The type of replication this instance uses
        def replication_type
          settings[:replication_type]
        end

        ##
        # Deletes all client certificates and generates a new server SSL certificate for the instance
        #
        # @param [Boolean] async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def reset_ssl_config(async: true)
          requires :identity

          data = service.reset_instance_ssl_config(identity)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.tap { |o| o.wait_for { ready? } unless async }
        end

        ##
        # Restarts a Cloud SQL instance
        #
        # @param [Boolean] async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def restart(async: true)
          requires :identity

          data = service.restart_instance(identity)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.tap { |o| o.wait_for { ready? } unless async }
        end

        ##
        # Restores a backup of a Cloud SQL instance
        #
        # @param [String] backup_run_id The identifier of the backup configuration
        # @param [Boolean] async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def restore_backup(backup_run_id, async: true)
          requires :identity

          data = service.restore_instance_backup(identity, backup_run_id)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.tap { |o| o.wait_for { ready? } unless async }
        end

        ##
        # Saves a Cloud SQL instance
        #
        # @return [Fog::Google::SQL::Instance] Instance resource
        def save
          etag ? update : create
        end

        ##
        # Returns the version of instance settings
        #
        # @return [String] The version of instance settings
        def settings_version
          settings[:settings_version]
        end

        ##
        # Lists all of the current SSL certificates for the instance
        #
        # @return [Array<Fog::Google::SQL::SslCert>] List of SSL certificate resources
        def ssl_certs
          requires :identity

          service.ssl_certs.all(identity)
        end

        ##
        # Returns the tier of service for this instance
        #
        # @return [String] The tier of service for this instance
        def tier
          settings[:tier]
        end

        ##
        # Updates settings of a Cloud SQL instance
        #
        # @return [Fog::Google::SQL::Instance] Instance resource
        def update
          requires :identity, :settings_version, :tier

          data = service.update_instance(identity, settings_version, tier, settings)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(data.name)
          operation.wait_for { !pending? }
          reload
        end

        ##
        # Reload a Cloud SQL instance
        #
        # @return [Fog::Google::SQL::Instance] Instance resource
        def reload
          requires :identity

          data = collection.get(identity)
          merge_attributes(data.attributes)
          self
        end
      end
    end
  end
end
