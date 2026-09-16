module Fog
  module Google
    class Compute
      class Operation < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :client_operation_id, :aliases => "clientOperationId"
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :end_time, :aliases => "endTime"
        attribute :error
        attribute :http_error_message, :aliases => "httpErrorMessage"
        attribute :http_error_status_code, :aliases => "httpErrorStatusCode"
        attribute :insert_time, :aliases => "insertTime"
        attribute :operation_type, :aliases => "operationType"
        attribute :progress
        attribute :region
        attribute :self_link, :aliases => "selfLink"
        attribute :start_time, :aliases => "startTime"
        attribute :status
        attribute :status_message, :aliases => "statusMessage"
        attribute :target_id, :aliases => "targetId"
        attribute :target_link, :aliases => "targetLink"
        attribute :user
        attribute :warnings
        attribute :zone


        class ErrorInfo
          attr_accessor :code
          attr_accessor :error_details
          attr_accessor :location
          attr_accessor :message

          def initialize(attributes = {})
            @code          = attributes[:code]
            @error_details = attributes[:error_details]
            @location      = attributes[:location]
            @message       = attributes[:message]
          end

          def message_pretty
            message
          end
        end  # ErrorInfo

        # {:errors => [
        #    {:code => "QUOTA_EXCEEDED",
        #     :error_details => [
        #       {:quota_info=>
        #         {:dimensions=>{:region=>"us-east4"},
        #          :limit=>500,
        #          :limit_name=>"SSD-TOTAL-GB-per-project-region",
        #          :metric_name=>"compute.googleapis.com/ssd_total_storage"
        #         }
        #       }
        #     ],
        #     :message=>"Quota 'SSD_TOTAL_GB' exceeded.  Limit: 500.0 in region us-east4."
        #   }
        # ]}
        class QuotaInfo < ErrorInfo
          def initialize(attributes = {})
            code = attributes[:code]
            raise Fog::Errors::Error.new("Invalid error code: #{code}") if code != "QUOTA_EXCEEDED"

            super(attributes)
          end

          def quota_infos
            return [] unless error_details.is_a?(Array)

            error_details_quota_infos = error_details.select{|ed| ed.is_a?(Hash) && ed.has_key?(:quota_info)}
            error_details_quota_infos.map{|ed| ed[:quota_info]}
          end

          def message_pretty
            msg = super.gsub(/\s*Limit.*region.*[^.]+./, "")

            quota_infos.each do |qi|
              dimensions = qi[:dimensions]  if qi.is_a?(Hash)
              limit      = qi[:limit]       if qi.is_a?(Hash)
              metric     = qi[:metric_name] if qi.is_a?(Hash)

              region = dimensions[:region] if dimensions.is_a?(Hash)

              limit_msg = "  Limit: #{limit.to_f}"           if limit.is_a?(Numeric)
              limit_msg = "#{limit_msg} #{metric}"           if limit_msg && metric
              limit_msg = "#{limit_msg} in region #{region}" if limit_msg && region.is_a?(String)
              limit_msg = "#{limit_msg}."                    if limit_msg

              msg = "#{msg}#{limit_msg}"
            end

            msg
          end
        end  # QuotaInfo

        # {:errors => [
        #    {:code => "ZONE_RESOURCE_POOL_EXHAUSTED_WITH_DETAILS",
        #     :error_details => [
        #       {:help => {:links=>[{:description=>"Troubleshooting documentation", :url=>"https://cloud.google.com/compute/docs/resource-error"}]}},
        #       {:localized_message => {
        #          :locale=>"en-US",
        #          :message=> "A c3d-highmem-4 VM instance is currently unavailable in the us-east4-b zone. Try requesting the VM in another zone. For more information, view the troubleshooting documentation."
        #       }},
        #       {:error_info => {
        #          :domain=>"compute.googleapis.com",
        #          :metadatas=>{:attachment=>"", :vmType=>"c3d-highmem-4", :zone=>"us-east4-b", :zonesAvailable=>""},
        #          :reason=>"stockout"
        #       }}
        #     ],
        #     :message => "The zone 'projects/projname/zones/us-east4-b' does not have enough resources available to fulfill the request.  '(resource type:compute)'."
        #   }
        # ]}
        class ResourcePoolInfo < ErrorInfo
          def initialize(attributes = {})
            code = attributes[:code]
            raise Fog::Errors::Error.new("Invalid error code: #{code}") if code !~ /RESOURCE_POOL_EXHAUSTED/

            super(attributes)
          end

          # Placeholder in case there is a need for future message formatting
          # def message_pretty
          # end
        end


        def error?
          ! error.nil?
        end

        def errors
          error? ? error[:errors] : nil
        end

        def ready?
          status == DONE_STATE
        end

        def pending?
          status == PENDING_STATE
        end

        def region_name
          region.nil? ? nil : region.split("/")[-1]
        end

        def zone_name
          zone.nil? ? nil : zone.split("/")[-1]
        end

        # https://docs.cloud.google.com/compute/docs/reference/rest/v1/errors
        def error_info_class(code)
          case code
          when "QUOTA_EXCEEDED" then QuotaInfo

          when "REGION_RESOURCE_POOL_EXHAUSTED_WITH_DETAILS" then ResourcePoolInfo
          when "RESOURCE_POOL_EXHAUSTED"                     then ResourcePoolInfo
          when "ZONE_RESOURCE_POOL_EXHAUSTED"                then ResourcePoolInfo
          when "ZONE_RESOURCE_POOL_EXHAUSTED_WITH_DETAILS"   then ResourcePoolInfo

          else
            ErrorInfo
          end
        end

        # Returns an array of ErrorInfo objects derived from the raw error hash.
        def error_infos
          return [] unless error.is_a?(Hash)
          return [] unless errors.is_a?(Array)

          errors.map do |err|
            klass = error_info_class(err[:code])
            klass.new(
              code:          err[:code],
              message:       err[:message],
              location:      err[:location],
              error_details: err[:error_details]
            )
          end
        end

        # Convenience helper: return the first error (most Google APIs provide only one).
        def primary_error
          error_infos.first
        end

        def destroy
          requires :identity

          if zone
            service.delete_zone_operation(zone, identity)
          elsif region
            service.delete_region_operation(region, identity)
          else
            service.delete_global_operation(identity)
          end
          true
        end

        def reload
          requires :identity

          data = collection.get(identity, zone, region)
          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        PENDING_STATE = "PENDING".freeze
        RUNNING_STATE = "RUNNING".freeze
        DONE_STATE = "DONE".freeze
      end
    end
  end
end
