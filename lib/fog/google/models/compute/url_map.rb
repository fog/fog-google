require "fog/core/model"

module Fog
  module Compute
    class Google
      class UrlMap < Fog::Model
        identity :name

        attribute :kind, :aliases => "kind"
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :default_service, :aliases => "defaultService"
        attribute :description, :aliases => "description"
        attribute :fingerprint, :aliases => "fingerprint"
        attribute :host_rules, :aliases => "hostRules"
        attribute :id, :aliases => "id"
        attribute :path_matchers, :aliases => "pathMatchers"
        attribute :self_link, :aliases => "selfLink"
        attribute :tests, :aliases => "tests"

        def save
          requires :name, :default_service

          options = {
            "defaultService" => default_service,
            "description" => description,
            "fingerprint" => fingerprint,
            "hostRules" => host_rules,
            "pathMatchers" => path_matchers,
            "tests" => tests
          }

          data = service.insert_url_map(name, options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data["name"])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :name

          operation = service.delete_url_map(name)
          unless async
            Fog.wait_for do
              operation = service.get_global_operation(operation.body["name"])
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def validate
          service.validate_url_map self
        end

        def add_host_rules(hostRules)
          hostRules = [hostRules] unless hostRules.class == Array
          service.update_url_map(self, hostRules)
          reload
        end

        def add_path_matchers(pathMatchers, hostRules)
          pathMatchers = [pathMatchers] unless pathMatchers.class == Array
          hostRules = [hostRules] unless hostRules.class == Array
          service.update_url_map(self, hostRules, pathMatchers)
          reload
        end

        def ready?
          service.get_url_map(name)
          true
        rescue Fog::Errors::NotFound
          false
        end

        def reload
          requires :name

          return unless data = begin
            collection.get(name)
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
