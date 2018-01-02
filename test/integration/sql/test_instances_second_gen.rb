require "helpers/integration_test_helper"
require "helpers/client_helper"
require "integration/sql/sql_instances_shared"

##
# Tests requests and resources specific to 2nd generation instances.

class TestSecondGenInstances < TestSqlInstancesShared
  # Test
  INSTANCE_NAME = "fogtest2ndgen-#{Fog::Mock.random_letters(8)}".freeze

  def some_clone_name
    "#{INSTANCE_NAME}-clone"
  end

  def some_instance_name
    # Create one test instance per generation per test suite.
    INSTANCE_NAME.tap do |name|
      begin
        @client.get_instance(name)
      rescue ::Google::Apis::ClientError
        create_test_instance(INSTANCE_NAME,
                             TEST_SQL_TIER_SECOND,
                             TEST_SQL_REGION_SECOND)
      end
    end
  end

  def delete_test_resources
    super
    try_delete_instance(some_clone_name)
  end

  def test_restore_backup_run
    data = { :description => "test", :instance => some_instance_name }
    wait_until_complete { @client.insert_backup_run(some_instance_name, data) }

    backup_run = @client.backup_runs.all(some_instance_name).first
    instance = @client.instances.get(some_instance_name)

    # Wait for backup operation to be finished
    # or fail if it never finishes.
    instance.restore_backup(backup_run.id, :async => false)
  end

  def test_backup_runs
    description = "test backup run"
    op = wait_until_complete do
      @client.insert_backup_run(
        some_instance_name,
        :description => description
      )
    end

    assert_equal(op.operation_type, "BACKUP_VOLUME")
    runs = @client.backup_runs.all(some_instance_name)
    assert_operator(runs.size, :>, 0, "expected at least one backup run")
    assert_equal(description, runs.first.description)

    created_run = @client.backup_runs.get(some_instance_name, runs.first.id)
    assert_equal(created_run, runs.first)

    wait_until_complete do
      @client.delete_backup_run(some_instance_name, runs.first.id)
    end

    deleted_run = @client.backup_runs.get(some_instance_name, runs.first.id)
    assert_equal("DELETED", deleted_run.status)
  end

  def test_clone
    instance = @client.instances.get(some_instance_name)
    instance.clone(some_clone_name, :async => false)
    cloned = @client.instances.get(some_clone_name)

    # Sanity check some attributes
    compare = %i(current_disk_size tier project region ip_configuration_require_ssl activation_policy)
    compare.each do |k|
      v = instance.attributes[k]
      cloned_v = cloned.attributes[k]
      if v.nil?
        assert_nil(cloned_v)
      else
        assert_equal(v, cloned_v, "attribute #{k} in original instance is #{v}, cloned = #{cloned_v}")
      end
    end
  end
end
