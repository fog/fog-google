require "helpers/integration_test_helper"
require "integration/factories/sql_instances_factory"
# Client helper is imported for `wait_until_complete`
# TODO: Remove when fog-google#339 or fog-google#340 is resolved
require "helpers/client_helper"

class TestSQLV2Instances < FogIntegrationTest
  include TestCollection
  # TODO: Remove when fog-google#339 or fog-google#340 is resolved
  include ClientHelper
  attr_reader :client

  def setup
    @subject = Fog::Google[:sql].instances
    @factory = SqlInstancesFactory.new(namespaced_name)
    @backup_runs = Fog::Google[:sql].backup_runs
    # TODO: Remove after BackupRuns get save/reload - fog-google#339
    # See https://github.com/fog/fog-google/issues/339
    @client = Fog::Google::SQL.new
  end

  def test_update
    instance = @factory.create

    settings_version = instance.settings_version
    labels = {
      :foo => "bar"
    }
    instance.settings[:user_labels] = labels
    instance.save

    updated = @subject.get(instance.name)
    assert_equal(labels, updated.settings[:user_labels])
    assert_operator(updated.settings_version, :>, settings_version)
  end

  def test_default_settings
    instance = @factory.create
    assert_equal([], instance.ssl_certs, "new instance should have 0 initial ssl certs")
  end

  def test_restore_backup_run
    instance = @factory.create

    data = { :description => "test", :instance => instance.name }
    wait_until_complete { @client.insert_backup_run(instance.name, data) }

    backup_run = @backup_runs.all(instance.name).first

    # Wait for backup operation to be finished
    # or fail if it never finishes.
    instance.restore_backup(backup_run.id, :async => false)
  end

  def test_backup_runs
    # TODO: This probably can get pulled into the test above as those tests
    # very expensive time-wize (5 minutes or so each)
    instance = @factory.create

    description = "test backup run"
    operation = wait_until_complete do
      @client.insert_backup_run(
        instance.name,
        :description => description
      )
    end

    assert_equal(operation.operation_type, "BACKUP_VOLUME")
    runs = @backup_runs.all(instance.name)
    assert_operator(runs.size, :>, 0, "expected at least one backup run")
    assert_equal(description, runs.first.description)

    created_run = @backup_runs.get(instance.name, runs.first.id)
    assert_equal(created_run, runs.first)

    wait_until_complete do
      @client.delete_backup_run(instance.name, runs.first.id)
    end

    deleted_run = @backup_runs.get(instance.name, runs.first.id)
    assert_equal("DELETED", deleted_run.status)
  end

  def test_clone
    instance = @factory.create
    instance.clone("#{instance.name}-clone", :async => false)
    cloned = @client.instances.get("#{instance.name}-clone")

    # Sanity check some attributes
    compare = %i(current_disk_size project region ip_configuration_require_ssl activation_policy)
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
