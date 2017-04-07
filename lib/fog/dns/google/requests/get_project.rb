module Fog
  module DNS
    class Google
      ##
      # Fetches the representation of an existing Project. Use this method to look up the limits on the number of
      # resources that are associated with your project.
      #
      # @see https://developers.google.com/cloud-dns/api/v1/projects/get
      class Real
        def get_project(identity)
          @dns.get_project(identity)
        end
      end

      class Mock
        def get_project(identity)
          body = {
            "kind" => 'dns#project',
            "number" => Fog::Mock.random_numbers(12).to_s,
            "id" => identity,
            "quota" => {
              "kind" => 'dns#quota',
              "managedZones" => 100,
              "rrsetsPerManagedZone" => 10_000,
              "rrsetAdditionsPerChange" => 100,
              "rrsetDeletionsPerChange" => 100,
              "totalRrdataSizePerChange" => 10_000,
              "resourceRecordsPerRrset" => 20
            }
          }

          build_excon_response(body)
        end
      end
    end
  end
end
