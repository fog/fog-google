##
# Helper mixin for tests (especially compute-based ones). Provide access to the
# client in use via the #client method to use.

module ClientHelper
  # Check to see if an operation is finished.
  #
  # @param op [Google::Apis::ComputeV1::Operation] the operation object returned from an api call
  # @return [Boolean] true if the operation is no longer executing, false
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

  # Pause execution until an operation returned from a passed block is finished.
  #
  # @example Pause until server is provisioned
  #   @result = wait_until_complete { client.insert_server(name, zone, opts) }
  # @yieldreturn [Google::Apis::ComputeV1::Operation] the resulting operation object from a block.
  # @return the result of the operation
  def wait_until_complete
    result = yield
    return result unless result.kind == "compute#operation"

    region = result.region
    zone = result.zone
    Fog.wait_for { operation_finished?(result) }
    if zone.nil?
      client.get_region_operation(region, result.name)
    else
      client.get_zone_operation(zone, result.name)
    end
  end
end
