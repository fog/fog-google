module Fog
  module Google
    class Monitoring
      ##
      # List the data points of the time series that match the metric and labels values and that have data points
      # in the interval
      #
      # @see https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list
      class Real
        def list_timeseries(options = {})
          api_method = @monitoring.projects.time_series.list
          parameters = {
            "name" => "projects/#{@project}"
          }
          if options.key?(:interval)
            interval = options[:interval]
            parameters["interval.endTime"] = interval[:end_time] if interval.key?(:end_time)
            parameters["interval.startTime"] = interval[:start_time] if interval.key?(:start_time)
          end

          if options.key?(:aggregation)
            aggregation = options[:aggregation]
            parameters["aggregation.alignmentPeriod"] = aggregation[:alignment_period] if aggregation.key?(:alignment_period)
            parameters["aggregation.crossSeriesReducer"] = aggregation[:cross_series_reducer] if aggregation.key?(:cross_series_reducer)
            parameters["aggregation.groupByFields"] = aggregation[:group_by_fields] if aggregation.key?(:group_by_fields)
            parameters["aggregation.perSeriesAligner"] = aggregation[:per_series_aligner] if aggregation.key?(:per_series_aligner)
          end

          parameters["filter"] = options[:filter] if options.key?(:filter)
          parameters["orderBy"] = options[:order_by] if options.key?(:order_by)
          parameters["pageSize"] = options[:page_size] if options.key?(:page_size)
          parameters["pageToken"] = options[:page_token] if options.key?(:page_token)
          parameters["view"] = options[:view] if options.key?(:view)

          unless parameters.key?("interval.startTime")
            raise ArgumentError.new("option :interval must have :start_time value for listing timeseries")
          end

          unless parameters.key?("interval.endTime")
            raise ArgumentError.new("option :interval must have :end_time value for listing timeseries")
          end

          unless parameters.key?("filter")
            raise ArgumentError.new("options[:filter] value is required to list timeseries")
          end

          request(api_method, parameters)
        end
      end

      class Mock
        def list_timeseries(interval, _options = {})
          body = {
            "timeSeries" => [
              {
                "metric" => {
                  "labels" => { "instance_name" => "emilyye-dev" },
                  "type" => "compute.googleapis.com/instance/cpu/usage_time"
                },
                "resource" => {
                  "type" => "gce_instance",
                  "labels" => {
                    "instance_id" => "3959348537894302241",
                    "zone" => "us-central1-c",
                    "project_id" => @project
                  }
                },
                "metricKind" => "DELTA",
                "valueType" => "DOUBLE",
                "points" => [
                  {
                    "interval" => interval,
                    "value" => {
                      "doubleValue" => 1.8277230720141233
                    }
                  }
                ]
              }
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
