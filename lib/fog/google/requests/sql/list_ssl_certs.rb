module Fog
  module Google
    class SQL
      ##
      # Lists all of the current SSL certificates for the instance
      #
      # @see https://cloud.google.com/sql/docs/mysql/admin-api/v1beta4/sslCerts/list

      class Real
        def list_ssl_certs(instance_id)
          @sql.list_ssl_certs(@project, instance_id)
        end
      end

      class Mock
        def list_ssl_certs(_instance_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
