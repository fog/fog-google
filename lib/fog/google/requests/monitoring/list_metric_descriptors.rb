module Fog
  module Google
    class Monitoring
      ##
      # Lists metric descriptors that match a filter.
      #
      # @see https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.metricDescriptors/list
      class Real
        def list_metric_descriptors(options = {})
          api_method = @monitoring.projects.metric_descriptors.list
          parameters = {
            "name" => "projects/#{@project}"
          }
          parameters["filter"] = options[:filter] if options.key?(:filter)
          parameters["pageSize"] = options[:page_size] if options.key?(:page_size)
          parameters["pageToken"] = options[:page_token] if options.key?(:page_token)

          puts parameters
          request(api_method, parameters)
        end
      end

      class Mock
        def list_metric_descriptors(_options = {})
          body = {
            "metricDescriptors" => [
              {
                "type" => "compute.googleapis.com/instance/cpu/reserved_cores",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/cpu/reserved_cores",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  }
                ],
                "metricKind" => "GAUGE",
                "valueType" => "DOUBLE",
                "unit" => "1",
                "description" => "Number of cores reserved on the host of the instance.",
                "displayName" => "Reserved cores"
              },
              {
                "type" => "compute.googleapis.com/instance/cpu/usage_time",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/cpu/usage_time",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "DOUBLE",
                "unit" => "s",
                "description" => "Delta CPU usage for all cores, in seconds. To compute the per-core CPU utilization fraction, divide this value by (end-start)*N, where end and start define this value's time interval and N is `compute.googleapis.com/instance/cpu/reserved_cores` at the end of the interval.",
                "displayName" => "CPU usage"
              },
              {
                "type" => "compute.googleapis.com/instance/disk/read_bytes_count",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/disk/read_bytes_count",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  },
                  {
                    "key" => "device_name",
                    "description" => "The name of the disk device."
                  },
                  {
                    "key" => "storage_type",
                    "description" => "The storage type => `pd-standard` or `pd-ssd`."
                  },
                  {
                    "key" => "device_type",
                    "description" => "The disk type => `ephemeral` or `permanent`."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "INT64",
                "unit" => "By",
                "description" => "Delta count of bytes read from disk.",
                "displayName" => "Disk read bytes"
              },
              {
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/disk/read_ops_count",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  },
                  {
                    "key" => "device_name",
                    "description" => "The name of the disk device."
                  },
                  {
                    "key" => "storage_type",
                    "description" => "The storage type => `pd-standard` or `pd-ssd`."
                  },
                  {
                    "key" => "device_type",
                    "description" => "The disk type => `ephemeral` or `permanent`."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "INT64",
                "unit" => "1",
                "description" => "Delta count of disk read IO operations.",
                "displayName" => "Disk read operations",
                "type" => "compute.googleapis.com/instance/disk/read_ops_count"
              },
              {
                "type" => "compute.googleapis.com/instance/disk/write_bytes_count",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/disk/write_bytes_count",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  },
                  {
                    "key" => "device_name",
                    "description" => "The name of the disk device."
                  },
                  {
                    "key" => "storage_type",
                    "description" => "The storage type => `pd-standard` or `pd-ssd`."
                  },
                  {
                    "key" => "device_type",
                    "description" => "The disk type => `ephemeral` or `permanent`."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "INT64",
                "unit" => "By",
                "description" => "Delta count of bytes written to disk.",
                "displayName" => "Disk write bytes"
              },
              {
                "type" => "compute.googleapis.com/instance/disk/write_ops_count",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/disk/write_ops_count",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  },
                  {
                    "key" => "device_name",
                    "description" => "The name of the disk device."
                  },
                  {
                    "key" => "storage_type",
                    "description" => "The storage type => `pd-standard` or `pd-ssd`."
                  },
                  {
                    "key" => "device_type",
                    "description" => "The disk type => `ephemeral` or `permanent`."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "INT64",
                "unit" => "1",
                "description" => "Delta count of disk write IO operations.",
                "displayName" => "Disk write operations"
              },
              {
                "type" => "compute.googleapis.com/instance/network/received_packets_count",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/network/received_packets_count",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  },
                  {
                    "key" => "loadbalanced",
                    "valueType" => "BOOL",
                    "description" => "Whether traffic was received by an L3 loadbalanced IP address assigned to the VM. Traffic that is externally routed to the VM's standard internal or external IP address, such as L7 loadbalanced traffic, is not considered to be loadbalanced in this metric."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "INT64",
                "unit" => "1",
                "description" => "Delta count of packets received from the network.",
                "displayName" => "Received packets"
              },
              {
                "type" => "compute.googleapis.com/instance/network/sent_bytes_count",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/network/sent_bytes_count",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  },
                  {
                    "key" => "loadbalanced",
                    "valueType" => "BOOL",
                    "description" => "Whether traffic was sent from an L3 loadbalanced IP address assigned to the VM. Traffic that is externally routed from the VM's standard internal or external IP address, such as L7 loadbalanced traffic, is not considered to be loadbalanced in this metric."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "INT64",
                "unit" => "By",
                "description" => "Delta count of bytes sent over the network.",
                "displayName" => "Sent bytes"
              },
              {
                "type" => "compute.googleapis.com/instance/network/sent_packets_count",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/network/sent_packets_count",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  },
                  {
                    "key" => "loadbalanced",
                    "valueType" => "BOOL",
                    "description" => "Whether traffic was sent from an L3 loadbalanced IP address assigned to the VM. Traffic that is externally routed from the VM's standard internal or external IP address, such as L7 loadbalanced traffic, is not considered to be loadbalanced in this metric."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "INT64",
                "unit" => "1",
                "description" => "Delta count of packets sent over the network.",
                "displayName" => "Sent packets"
              },
              {
                "type" => "compute.googleapis.com/instance/uptime",
                "name" => "projects/#{@project}/metricDescriptors/compute.googleapis.com/instance/uptime",
                "labels" => [
                  {
                    "key" => "instance_name",
                    "description" => "The name of the VM instance."
                  }
                ],
                "metricKind" => "DELTA",
                "valueType" => "DOUBLE",
                "unit" => "s",
                "description" => "How long the VM has been running, in seconds.",
                "displayName" => "Uptime"
              }
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
