module Fog
  module Google
    class Compute
      class Projects < Fog::Collection
        model Fog::Google::Compute::Project

        def get(identity)
          if project = service.get_project(identity).to_h
            new(project)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
