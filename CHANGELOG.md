# 1.4.0

## User-facing changes

### Compute

- c064f4d Bump Google API client to 0.23 [temikus] 

- 0f3c167 Fix get_health when called with an instance name [bpaquet] 

- 985cd02 Fixed `Fog::Compute::Google::Server.set_metadata` and added an alternative better format [temikus] 

- 085aea3 Add `Fog::Compute::Google::Server.public_ip_address` helper [temikus] 

- 82cde97 Fix source_image selection to get the image from name if the format is not compatible with new Google API Client [temikus] 

- fb56ca2 Fixing `Fog::Compute::Google::InstanceGroup.add_instance` method [temikus] 

### Storage

- b9c224d Add support for using predefined ACLs, refactor valid ACLs [vimutter]

- c1be700 Fix string key instead of symbol for subnetworks listing [tumido] 

- 2c0dece Fixed trailing spaces and added data presence check to `Fog::Storage::GoogleJSON.put_object` [vimutter] 

- 79163a5  add fog_public support in JSON API [jayhsu21]

## Dev changes

- a2e46a2 Added collection/model unit tests to be run by Travis CI [temikus] 

- cb42ede Added target pool tests [temikus] 

- 1c194b3 Updated CI pipeline to run in parallel, broke out test tasks [temikus] 

- a652b02 Fixed all broken integration tests, all tests now pass in CI [temikus]