require 'fog/core/collection'
require 'fog/google/models/compute/image'

module Fog
  module Compute
    class Google
      class Images < Fog::Collection
        model Fog::Compute::Google::Image

        # NOTE: Not everyone has access to these projects because of the
        # licenses needed to use some of them.
        # https://developers.google.com/compute/docs/premium-operating-systems
        GLOBAL_PROJECTS = [
          'centos-cloud',
          'coreos-cloud',
          'debian-cloud',
          'google-containers',
          'opensuse-cloud',
          'rhel-cloud',
          'suse-cloud',
          'ubuntu-os-cloud'
        ]

        # Returns the current or a specific project (if provided) images
        # followed by the global project ones. Same behaviour than
        # https://cloud.google.com/sdk/gcloud/reference/compute/images/list
        def all(options = {})
          project_id = options[:project] || self.service.project
          data = []
          all_projects = [ project_id ] + GLOBAL_PROJECTS

          all_projects.each do |project|
            begin
              images = service.list_images(project).body["items"] || []

              # Keep track of the project in which we found the image(s)
              images.each { |img| img[:project] = project }
              data += images
            rescue Fog::Errors::NotFound
              # Not everyone has access to every Global Project. Requests
              # return 404 if you don't have access.
              next
            end
          end

          load(data)
        end

        def get(identity, options = {})
          project_id = options[:project] || self.service.project
          all_projects = [ project_id ] + GLOBAL_PROJECTS

          data = nil
          all_projects.each do |project|
            begin
              data = service.get_image(identity, project).body
              data[:project] = project
            rescue Fog::Errors::NotFound
              next
            else
              break
            end
          end
          return nil if data.nil?
          new(data)
        end
      end
    end
  end
end
