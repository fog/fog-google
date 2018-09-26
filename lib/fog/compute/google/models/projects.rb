module Fog
  module Compute
    class Google
      class Projects < Fog::Collection
        model Fog::Compute::Google::Project

        def get(identity)
          if identity
            project = service.get_project(identity).to_h
            return new(project)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
