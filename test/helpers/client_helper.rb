##
# Helper mixin for tests (especially compute-based ones). Provide access to the
# client in use via the #client method to use.

module ClientHelper
  # Check to see if an operation is finished.
  #
  # @param op [Excon::Response] the operation object returned from an api call
  # @return [Boolean] true if the operation is no longer executing, false
  #   otherwise
  def operation_finished?(op)
    # TODO: support both zone and region operations
    region = op[:body]["region"]
    name = op[:body]["name"]

    result = client.get_region_operation(region, name)
    !%w(PENDING RUNNING).include?(result[:body]["status"])
  end

  # Pause execution until an operation returned from a passed block is finished.
  #
  # @example Pause until server is provisioned
  #   @result = wait_until_complete { client.insert_server(name, zone, opts) }
  # @yieldreturn [Excon::Response] the resulting operation object from a block.
  # @return [Excon::Response] the final completed operation object
  def wait_until_complete
    result = yield
    return result unless result[:body]["kind"] == "compute#operation"

    # TODO: support both zone and region operations
    region = result[:body]["region"]
    Fog.wait_for { operation_finished?(result) }
    client.get_region_operation(region, result[:body]["name"])
  end
end
