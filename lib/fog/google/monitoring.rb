module Fog
  module Google
    class Monitoring < Fog::Service
      autoload :Mock, File.expand_path("../monitoring/mock", __FILE__)
      autoload :Real, File.expand_path("../monitoring/real", __FILE__)

      requires :google_project
      recognizes :google_client_email, :google_key_location, :google_key_string, :google_client,
                 :app_name, :app_version, :google_json_key_location, :google_json_key_string

      GOOGLE_MONITORING_API_VERSION    = "v2beta2".freeze
      GOOGLE_MONITORING_BASE_URL       = "https://www.googleapis.com/cloudmonitoring/".freeze
      GOOGLE_MONITORING_API_SCOPE_URLS = %w(https://www.googleapis.com/auth/monitoring).freeze

      ##
      # MODELS
      model_path "fog/google/models/monitoring"

      # Timeseries
      model :timeseries
      collection :timeseries_collection

      # TimeseriesDescriptors
      model :timeseries_descriptor
      collection :timeseries_descriptors

      # MetricDescriptors
      model :metric_descriptor
      collection :metric_descriptors

      ##
      # REQUESTS
      request_path "fog/google/requests/monitoring"

      # Timeseries
      request :list_timeseries

      # TimeseriesDescriptors
      request :list_timeseries_descriptors

      # MetricDescriptors
      request :list_metric_descriptors
    end
  end
end
