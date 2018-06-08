module Fog
  module Compute
    class Google
      class InstanceTemplates < Fog::Collection
        model Fog::Compute::Google::InstanceTemplate

        def all
          data = service.list_instance_templates.items || []
          load(data.map(&:to_h))
        end

        def get(identity)
          if instance_template = service.get_instance_template(identity)
            new(instance_template.to_h)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
