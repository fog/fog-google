module Fog
  module Compute
    class Google < Fog::Service
      autoload :Mock, File.expand_path("../google/mock", __FILE__)
      autoload :Real, File.expand_path("../google/real", __FILE__)

      requires :google_project
      recognizes :app_name, :app_version, :google_client_email, :google_key_location, :google_key_string,
                 :google_client, :google_json_key_location, :google_json_key_string, :google_extra_global_projects

      GOOGLE_COMPUTE_API_VERSION     = "v1"
      GOOGLE_COMPUTE_BASE_URL        = "https://www.googleapis.com/compute/"
      GOOGLE_COMPUTE_API_SCOPE_URLS  = %w(https://www.googleapis.com/auth/compute
                                          https://www.googleapis.com/auth/devstorage.read_write
                                          https://www.googleapis.com/auth/ndev.cloudman
                                          https://www.googleapis.com/auth/cloud-platform)
      GOOGLE_COMPUTE_DEFAULT_NETWORK = "default"
      RUNNING = "RUNNING"

      request_path "fog/compute/google/requests"
      request :list_servers
      request :list_aggregated_servers
      request :list_addresses
      request :list_aggregated_addresses
      request :list_disks
      request :list_aggregated_disks
      request :list_disk_types
      request :list_aggregated_disk_types
      request :list_firewalls
      request :list_images
      request :list_machine_types
      request :list_aggregated_machine_types
      request :list_networks
      request :list_zones
      request :list_regions
      request :list_global_operations
      request :list_region_operations
      request :list_zone_operations
      request :list_snapshots
      request :list_http_health_checks
      request :list_target_pools
      request :list_forwarding_rules
      request :list_routes
      request :list_backend_services
      request :list_global_forwarding_rules
      request :list_url_maps
      request :list_target_http_proxies
      request :list_zone_views
      request :list_region_views
      request :list_region_view_resources
      request :list_zone_view_resources
      request :list_target_instances
      request :list_aggregated_target_instances
      request :list_instance_groups
      request :list_aggregated_instance_groups
      request :list_instance_group_instances
      request :list_subnetworks
      request :list_aggregated_subnetworks

      request :get_server
      request :get_address
      request :get_disk
      request :get_disk_type
      request :get_firewall
      request :get_image
      request :get_machine_type
      request :get_network
      request :get_zone
      request :get_region
      request :get_snapshot
      request :get_global_operation
      request :get_region_operation
      request :get_zone_operation
      request :get_http_health_check
      request :get_target_pool
      request :get_target_pool_health
      request :get_forwarding_rule
      request :get_project
      request :get_route
      request :get_backend_service
      request :get_backend_service_health
      request :get_url_map
      request :get_global_forwarding_rule
      request :get_target_http_proxy
      request :get_zone_view
      request :get_region_view
      request :get_target_instance
      request :get_instance_group
      request :get_subnetwork

      request :delete_address
      request :delete_disk
      request :delete_snapshot
      request :delete_firewall
      request :delete_image
      request :delete_network
      request :delete_server
      request :delete_global_operation
      request :delete_region_operation
      request :delete_zone_operation
      request :delete_http_health_check
      request :delete_target_pool
      request :delete_forwarding_rule
      request :delete_route
      request :delete_backend_service
      request :delete_url_map
      request :delete_target_http_proxy
      request :delete_global_forwarding_rule
      request :delete_zone_view
      request :delete_region_view
      request :delete_target_instance
      request :delete_instance_group
      request :delete_subnetwork

      request :insert_address
      request :insert_disk
      request :insert_firewall
      request :insert_image
      request :insert_network
      request :insert_server
      request :insert_snapshot
      request :insert_http_health_check
      request :insert_target_pool
      request :insert_forwarding_rule
      request :insert_route
      request :insert_backend_service
      request :insert_url_map
      request :insert_target_http_proxy
      request :insert_global_forwarding_rule
      request :insert_zone_view
      request :insert_region_view
      request :insert_target_instance
      request :insert_instance_group
      request :insert_subnetwork

      request :set_metadata
      request :set_tags
      request :set_forwarding_rule_target
      request :set_global_forwarding_rule_target
      request :set_target_http_proxy_url_map

      request :add_target_pool_instances
      request :add_target_pool_health_checks
      request :add_backend_service_backends
      request :add_url_map_host_rules
      request :add_url_map_path_matchers
      request :add_zone_view_resources
      request :add_region_view_resources
      request :add_instance_group_instance

      request :remove_target_pool_instances
      request :remove_target_pool_health_checks
      request :set_common_instance_metadata
      request :remove_instance_group_instance

      request :attach_disk
      request :detach_disk
      request :get_server_serial_port_output
      request :reset_server
      request :set_server_disk_auto_delete
      request :set_server_scheduling
      request :add_server_access_config
      request :delete_server_access_config
      request :update_url_map
      request :validate_url_map
      request :start_server
      request :stop_server

      model_path "fog/compute/google/models"
      model :server
      collection :servers

      model :image
      collection :images

      model :flavor
      collection :flavors

      model :disk
      collection :disks

      model :disk_type
      collection :disk_types

      model :address
      collection :addresses

      model :operation
      collection :operations

      model :snapshot
      collection :snapshots

      model :zone
      collection :zones

      model :region
      collection :regions

      model :http_health_check
      collection :http_health_checks

      model :target_pool
      collection :target_pools

      model :forwarding_rule
      collection :forwarding_rules

      model :project
      collection :projects

      model :firewall
      collection :firewalls

      model :network
      collection :networks

      model :route
      collection :routes

      model :backend_service
      collection :backend_services

      model :target_http_proxy
      collection :target_http_proxies

      model :url_map
      collection :url_maps

      model :global_forwarding_rule
      collection :global_forwarding_rules

      model :resource_view
      collection :resource_views

      model :target_instance
      collection :target_instances

      model :instance_group
      collection :instance_groups

      model :subnetwork
      collection :subnetworks
    end
  end
end
