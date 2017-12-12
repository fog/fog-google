module Fog
  module Google
    class SQL
      ##
      # Creates a new Cloud SQL instance
      #
      # @see https://cloud.google.com/sql/docs/mysql/admin-api/v1beta4/instances/insert

      class Real
        def insert_instance(name, tier, instance = {})
          instance = ::Google::Apis::SqladminV1beta4::DatabaseInstance.new(instance)
          instance.name = name
          instance.settings = ::Google::Apis::SqladminV1beta4::Settings.new(instance.settings || {})
          instance.settings.tier = tier
          @sql.insert_instance(@project, instance)
        end
      end

      class Mock
        def insert_instance(_name, _tier, _options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
