module Fog
  module Parsers
    module Storage
      module Google
        autoload :AccessControlList, File.expand_path("../google/access_control_list", __FILE__)
        autoload :CopyObject, File.expand_path("../google/copy_object", __FILE__)
        autoload :GetBucket, File.expand_path("../google/get_bucket", __FILE__)
        autoload :GetBucketLogging, File.expand_path("../google/get_bucket_logging", __FILE__)
        autoload :GetBucketObjectVersions, File.expand_path("../google/get_bucket_object_versions", __FILE__)
        autoload :GetRequestPayment, File.expand_path("../google/get_request_payment", __FILE__)
        autoload :GetService, File.expand_path("../google/get_service", __FILE__)
      end
    end
  end
end
