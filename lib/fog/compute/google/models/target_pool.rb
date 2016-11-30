module Fog
  module Compute
    class Google
      class TargetPool < Fog::Model
        identity :name

        attribute :kind, :aliases => "kind"
        attribute :self_link, :aliases => "selfLink"
        attribute :id, :aliases => "id"
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description, :aliases => "description"
        attribute :region, :aliases => "region"
        attribute :health_checks, :aliases => "healthChecks"
        attribute :instances, :aliases => "instances"
        attribute :session_affinity, :aliases => "sessionAffinity"
        attribute :failover_ratio, :aliases => "failoverRatio"
        attribute :backup_pool, :aliases => "backupPool"

        def save
          requires :name, :region

          options = {
            "description" => description,
            "region" => region,
            "healthChecks" => health_checks,
            "instances" => instances,
            "sessionAffinity" => session_affinity,
            "failoverRatio" => failover_ratio,
            "backupPool" => backup_pool
          }

          data = service.insert_target_pool(name, region, options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data["name"], nil, data["region"])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :name, :region
          operation = service.delete_target_pool(name, region)
          unless async
            # wait until "DONE" to ensure the operation doesn't fail, raises
            # exception on error
            Fog.wait_for do
              operation = service.get_region_operation(region, operation.body["name"])
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def add_instance(instance)
          instance = instance.self_link unless instance.class == String
          service.add_target_pool_instances(self, [instance])
          reload
        end

        def remove_instance(instance)
          instance = instance.self_link unless instance.class == String
          service.remove_target_pool_instances(self, [instance])
          reload
        end

        def add_health_check(health_check)
          health_check = health_check.self_link unless health_check.class == String
          service.add_target_pool_health_checks(self, [health_check])
          reload
        end

        def remove_health_check(health_check)
          health_check = health_check.self_link unless health_check.class == String
          service.remove_target_pool_health_checks(self, [health_check])
          reload
        end

        def get_health(instance_name = nil)
          if instance_name
            instance = service.servers.get(instance_name)
            health_results = [service.get_target_pool_health(self, instance.self_link)]
          else
            health_results = instances.map do |instance_selflink|
              service.get_target_pool_health(self, instance_selflink)
            end
          end
          Hash[health_results]
        end

        def ready?
          service.get_target_pool(name, region)
          true
        rescue Fog::Errors::NotFound
          false
        end

        def region_name
          region.nil? ? nil : region.split("/")[-1]
        end

        def reload
          requires :name, :region

          return unless data = begin
            collection.get(name, region)
          rescue Excon::Errors::SocketError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        RUNNING_STATE = "READY"
      end
    end
  end
end
