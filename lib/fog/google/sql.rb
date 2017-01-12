module Fog
  module Google
    class SQL < Fog::Service
      autoload :Mock, File.expand_path("../sql/mock", __FILE__)
      autoload :Real, File.expand_path("../sql/real", __FILE__)

      requires :google_project
      recognizes(
        :google_client_email,
        :google_key_location,
        :google_key_string,
        :google_client,
        :app_name,
        :app_version,
        :google_json_key_location,
        :google_json_key_string
      )

      GOOGLE_SQL_API_VERSION    = "v1beta3"
      GOOGLE_SQL_BASE_URL       = "https://www.googleapis.com/sql/"
      GOOGLE_SQL_API_SCOPE_URLS = %w(https://www.googleapis.com/auth/sqlservice.admin
                                     https://www.googleapis.com/auth/cloud-platform)

      ##
      # MODELS
      model_path "fog/google/models/sql"

      # Backup Run
      model :backup_run
      collection :backup_runs

      # Flag
      model :flag
      collection :flags

      # Instance
      model :instance
      collection :instances

      # Operation
      model :operation
      collection :operations

      # SSL Certificate
      model :ssl_cert
      collection :ssl_certs

      # Tier
      model :tier
      collection :tiers

      ##
      # REQUESTS
      request_path "fog/google/requests/sql"

      # Backup Run
      request :get_backup_run
      request :list_backup_runs

      # Flag
      request :list_flags

      # Instance
      request :clone_instance
      request :delete_instance
      request :export_instance
      request :get_instance
      request :import_instance
      request :insert_instance
      request :list_instances
      request :reset_instance_ssl_config
      request :restart_instance
      request :restore_instance_backup
      request :set_instance_root_password
      request :update_instance

      # Operation
      request :get_operation
      request :list_operations

      # SSL Certificate
      request :delete_ssl_cert
      request :get_ssl_cert
      request :insert_ssl_cert
      request :list_ssl_certs

      # Tier
      request :list_tiers
    end
  end
end
