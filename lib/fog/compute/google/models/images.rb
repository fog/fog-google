module Fog
  module Compute
    class Google
      class Images < Fog::Collection
        model Fog::Compute::Google::Image

        # NOTE: some of these operating systems are premium and users will be
        # charged a license fee beyond the base Google Compute Engine VM
        # charges. See https://cloud.google.com/compute/docs/operating-systems/
        # for more info.
        GLOBAL_PROJECTS = %w(
          centos-cloud
          cos-cloud
          coreos-cloud
          debian-cloud
          rhel-cloud
          suse-cloud
          suse-sap-cloud
          ubuntu-os-cloud
          windows-cloud
          windows-sql-cloud
          opensuse-cloud
        ).freeze

        def all
          data = all_projects.map do |project|
            begin
              images = service.list_images(project).items || []
              # Keep track of the project in which we found the image(s)
              images.map { |img| img.to_h.merge(:project => project) }
            rescue ::Google::Apis::ClientError => e
              raise e unless e.status_code == 404
              # Not everyone has access to every Global Project. Requests
              # return 404 if you don't have access.
              next
            end
          end
          data = data.flatten

          load(data)
        end

        # Only return the non-deprecated list of images
        def current
          all.reject(&:deprecated)
        end

        def get(identity, project = nil)
          project.nil? ? projects = all_projects : projects = [project]
          data = nil
          projects.each do |proj|
            begin
              data = service.get_image(identity, proj).to_h
              data[:project] = proj
            rescue ::Google::Apis::ClientError => e
              next if e.status_code == 404
              break
            else
              break
            end
          end

          return nil if data.nil?
          new(data)
        end

        def get_from_family(family, project = nil)
          project.nil? ? projects = all_projects : projects = [project]
          data = nil

          projects.each do |proj|
            begin
              data = service.get_image_from_family(family, proj).to_h
              data[:project] = proj
            rescue ::Google::Apis::ClientError => e
              next if e.status_code == 404
              break
            end
          end
          return nil if data.nil?
          new(data)
        end

        private

        def all_projects
          # Search own project before global projects
          [service.project] + GLOBAL_PROJECTS + service.extra_global_projects
        end
      end
    end
  end
end
