##
# Helper mixin for tests (especially compute-based ones). Provide access to the
# client in use via the #client method to use.

module ClientHelper
  # Check to see if an compute operation is finished.
  #
  # @param op [Google::Apis::ComputeV1::Operation] the operation object returned from an api call
  # @return [Bolean] true if the operation is no longer executing, false
  #   otherwise
  def operation_finished?(op)
    region = op.region
    zone = op.zone
    name = op.name

    if zone.nil?
      result = client.get_region_operation(region, name)
    else
      result = client.get_zone_operation(zone, name)
    end
    !%w(PENDING RUNNING).include?(result.status)
  end

  # Check to see if an SQL operation is finished.
  #
  # @param op [Google::Apis::SqladminV1beta4::Operation] the operation object
  #   returned from an SQL Admin api call
  # @return [Boolean] true if the operation is no longer executing, false
  #   otherwise
  def sql_operation_finished?(op)
    result = client.get_operation(op.name)
    !%w(PENDING RUNNING).include?(result.status)
  end

  # Pause execution until an operation (compute or sql) returned
  # from a passed block is finished.
  #
  # @example Pause until server is provisioned
  #   @result = wait_until_complete { client.insert_server(name, zone, opts) }
  # @yieldreturn The resulting operation object from a block.
  # @return the result of the operation

  def wait_until_complete
    result = yield

    case result.kind
    when "compute#operation"
      region = result.region
      zone = result.zone
      Fog.wait_for { operation_finished?(result) }
      if zone.nil?
        client.get_region_operation(region, result.name)
      else
        client.get_zone_operation(zone, result.name)
      end
    when "sql#operation"
      Fog.wait_for { sql_operation_finished?(result) }
      client.get_operation(result.name)
    else
      result
    end
  end
end
