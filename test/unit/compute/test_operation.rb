require "helpers/test_helper"

class UnitTestOperation < Minitest::Test
  OP_NAME                   = "operation-1765631023137-645d501f04210-ccccdddd-eeeeffff"
  OP_REGION                 = "us-central1"

  OP_CLIENT_OPERATION_ID    = 3188330303322222222
  OP_CREATION_TIMESTAMP     = "2023-12-13T05:03:43.789-08:00"
  OP_END_TIME               = "2023-12-13T05:03:43.000-08:00"
  OP_ERROR                  = {}
  OP_HTTP_ERROR_MESSAGE     = "http error message"
  OP_HTTP_ERROR_STATUS_CODE = 499
  OP_ID                     = 3188330303311111111
  OP_INSERT_TIME            = "2023-12-13T05:03:43.456-08:00"
  OP_KIND                   = "compute#operation"
  OP_OPERATION_TYPE         = "insert"
  OP_PROGRESS               = 0
  OP_SELF_LINK              = "https://www.googleapis.com/compute/v1/projects/projname/zones/#{OP_REGION}-f/operations/#{OP_NAME}"
  OP_START_TIME             = "2023-12-13T05:03:43.461-08:00"
  OP_STATUS_MESSAGE         = "status message"
  OP_STATUS                 = "RUNNING"
  OP_TARGET_ID              = 8208437032700000000
  OP_TARGET_LINK            = "https://www.googleapis.com/compute/v1/projects/projname/zones/#{OP_REGION}-f/disks/diskname"
  OP_USER                   = "username@projname.iam.gserviceaccount.com"
  OP_WARNINGS               = []
  OP_ZONE                   = "https://www.googleapis.com/compute/v1/projects/projname/zones/#{OP_REGION}-f"

  def setup
    Fog.mock!
    @client = Fog::Compute.new(provider: "google",
                               google_project: "foo")
  end

  def teardown
    Fog.unmock!
  end

  def test_new_operation
    op = Fog::Google::Compute::Operation.new(
      :client_operation_id    => OP_CLIENT_OPERATION_ID,
      :creation_timestamp     => OP_CREATION_TIMESTAMP,
      :end_time               => OP_END_TIME,
      :error                  => OP_ERROR,
      :http_error_message     => OP_HTTP_ERROR_MESSAGE,
      :http_error_status_code => OP_HTTP_ERROR_STATUS_CODE,
      :id                     => OP_ID,
      :insert_time            => OP_INSERT_TIME,
      :kind                   => OP_KIND,
      :name                   => OP_NAME,
      :operation_type         => OP_OPERATION_TYPE,
      :progress               => OP_PROGRESS,
      :region                 => OP_REGION,
      :self_link              => OP_SELF_LINK,
      :start_time             => OP_START_TIME,
      :status_message         => OP_STATUS_MESSAGE,
      :status                 => OP_STATUS,
      :target_id              => OP_TARGET_ID,
      :target_link            => OP_TARGET_LINK,
      :user                   => OP_USER,
      :warnings               => OP_WARNINGS,
      :zone                   => OP_ZONE
    )

    assert_equal(OP_CLIENT_OPERATION_ID,    op.client_operation_id,    "Fog::Google::Compute::Operation client_operation_id is incorrect: #{op.client_operation_id}")
    assert_equal(OP_CREATION_TIMESTAMP,     op.creation_timestamp,     "Fog::Google::Compute::Operation creation_timestamp is incorrect: #{op.creation_timestamp}")
    assert_equal(OP_END_TIME,               op.end_time,               "Fog::Google::Compute::Operation end_time is incorrect: #{op.end_time}")
    assert_equal(OP_ERROR,                  op.error,                  "Fog::Google::Compute::Operation name is incorrect: #{op.error}")
    assert_equal(OP_HTTP_ERROR_MESSAGE,     op.http_error_message,     "Fog::Google::Compute::Operation http_error_message is incorrect: #{op.http_error_message}")
    assert_equal(OP_HTTP_ERROR_STATUS_CODE, op.http_error_status_code, "Fog::Google::Compute::Operation http_error_status_code is incorrect: #{op.http_error_status_code}")
    assert_equal(OP_ID,                     op.id,                     "Fog::Google::Compute::Operation id is incorrect: #{op.id}")
    assert_equal(OP_INSERT_TIME,            op.insert_time,            "Fog::Google::Compute::Operation insert_time is incorrect: #{op.insert_time}")
    assert_equal(OP_KIND,                   op.kind,                   "Fog::Google::Compute::Operation kind is incorrect: #{op.kind}")
    assert_equal(OP_NAME,                   op.name,                   "Fog::Google::Compute::Operation name is incorrect: #{op.name}")
    assert_equal(OP_OPERATION_TYPE,         op.operation_type,         "Fog::Google::Compute::Operation operation_type is incorrect: #{op.operation_type}")
    assert_equal(OP_PROGRESS,               op.progress,               "Fog::Google::Compute::Operation progress is incorrect: #{op.progress}")
    assert_equal(OP_REGION,                 op.region,                 "Fog::Google::Compute::Operation region is incorrect: #{op.region}")
    assert_equal(OP_SELF_LINK,              op.self_link,              "Fog::Google::Compute::Operation self_link is incorrect: #{op.self_link}")
    assert_equal(OP_START_TIME,             op.start_time,             "Fog::Google::Compute::Operation start_time is incorrect: #{op.start_time}")
    assert_equal(OP_STATUS_MESSAGE,         op.status_message,         "Fog::Google::Compute::Operation status_message is incorrect: #{op.status_message}")
    assert_equal(OP_STATUS,                 op.status,                 "Fog::Google::Compute::Operation status is incorrect: #{op.status}")
    assert_equal(OP_TARGET_ID,              op.target_id,              "Fog::Google::Compute::Operation target_id is incorrect: #{op.target_id}")
    assert_equal(OP_TARGET_LINK,            op.target_link,            "Fog::Google::Compute::Operation target_link is incorrect: #{op.target_link}")
    assert_equal(OP_USER,                   op.user,                   "Fog::Google::Compute::Operation user is incorrect: #{op.user}")
    assert_equal(OP_WARNINGS,               op.warnings,               "Fog::Google::Compute::Operation warnings incorrect: #{op.warnings}")
    assert_equal(OP_ZONE,                   op.zone,                   "Fog::Google::Compute::Operation zone is incorrect: #{op.zone}")
  end

  def test_message_pretty
    error= {:errors => [
             { :code =>"PERMISSIONS_ERROR",
               :error_details => [
               ],
               :location => "location",
               :message => "Permissions error."
             }
            ]}

    op = Fog::Google::Compute::Operation.new(:error => error, :name => OP_NAME)
    err = op.primary_error
    assert_equal "Permissions error.", err.message_pretty
  end

  def test_message_pretty_quota_single
    error= {:errors => [
             { :code =>"QUOTA_EXCEEDED",
               :error_details => [
                 {:quota_info => {:dimensions => {:region=>"us-east4"}, :limit => 500, :limit_name => "SSD-TOTAL-GB-per-project-region", :metric_name => "compute.googleapis.com/ssd_total_storage"}}
               ],
               :location => "location",
               :message => "Quota 'SSD_TOTAL_GB' exceeded.  Limit: 500.0 in region us-east4."
             }
            ]}

    op = Fog::Google::Compute::Operation.new(:error => error, :name => OP_NAME)
    err = op.primary_error
    assert_equal "Quota 'SSD_TOTAL_GB' exceeded.  Limit: 500.0 compute.googleapis.com/ssd_total_storage in region us-east4.", err.message_pretty
  end

  def test_message_pretty_quota_multi
    error= {:errors => [
             { :code =>"QUOTA_EXCEEDED",
               :error_details => [
                 {:quota_info => {:dimensions => {:region=>"us-east4"}, :limit => 500, :limit_name => "limit-name1", :metric_name => "compute.googleapis.com/ssd_total_storage"}},
                 {:quota_info => {:dimensions => {:region=>"us-west1"}, :limit => 999, :limit_name => "limit-name2", :metric_name => "compute.googleapis.com/ssd_xxxxx_storage"}}
               ],
               :location => "location",
               :message => "Quota 'SSD_TOTAL_GB' exceeded.  Limit: 500.0 in region us-east4."
             }
           ]
    }

    op = Fog::Google::Compute::Operation.new(:error => error, :name => OP_NAME)
    err = op.primary_error
    assert_equal "Quota 'SSD_TOTAL_GB' exceeded.  Limit: 500.0 compute.googleapis.com/ssd_total_storage in region us-east4.  Limit: 999.0 compute.googleapis.com/ssd_xxxxx_storage in region us-west1.", err.message_pretty
  end

  def test_message_pretty_quota_multi_missing_elements
    error= {:errors => [
             { :code =>"QUOTA_EXCEEDED",
               :error_details => [
                 {:quota_info => {                                      :limit => 500, :limit_name => "limit-name1", :metric_name => "compute.googleapis.com/ssd_total_storage"}},
                 {:quota_info => {:dimensions => {:region=>"us-east4"},                :limit_name => "limit-name2", :metric_name => "compute.googleapis.com/ssd_xxxxx_storage"}},
                 {:quota_info => {:dimensions => {:region=>"us-west1"}, :limit => 999, :limit_name => "limit-name2"}}
               ],
               :location => "location",
               :message => "Quota 'SSD_TOTAL_GB' exceeded."
             }
           ]
    }

    op = Fog::Google::Compute::Operation.new(:error => error, :name => OP_NAME)
    err = op.primary_error
    assert_equal "Quota 'SSD_TOTAL_GB' exceeded.  Limit: 500.0 compute.googleapis.com/ssd_total_storage.  Limit: 999.0 in region us-west1.", err.message_pretty
  end
end
