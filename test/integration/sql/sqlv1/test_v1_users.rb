require "helpers/integration_test_helper"
require "integration/factories/sql_v1_instances_factory"
require "integration/factories/sql_v1_users_factory"

class TestSQLV1Users < FogIntegrationTest
  # This test doesn't include TestCollection as Users is not a
  # classical Fog model, as it's tied to a particular instance
  # I.e.:
  # - Fog::Google::SQL.users.all() requires an instance
  # - API doesn't provide a GET request for Users model
  # See: https://cloud.google.com/sql/docs/mysql/admin-api/v1beta4/users

  def setup
    @subject = Fog::Google[:sql].users
    @factory = SqlV1UsersFactory.new(namespaced_name)
  end

  def teardown
    @factory.cleanup
  end

  def test_users
    # Create user
    user = @factory.create

    # Check user was created
    users = @subject.all(user.instance).select { |u| u.name == user.name }
    assert_equal(1, users.size, "expected user to have been created")

    # Delete user
    users.first.destroy(:async => false)
    assert_empty(
      @subject.all(user.instance).select { |u| u.name == user.name },
      "expected no user #{user.name}"
    )
  end
end
