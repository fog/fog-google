# Changelog
All notable changes to this project will be documented in this file.
The format is loosely based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 1.7.1

### User-facing

#### Fixed

- \#412 Fixed `Fog::Storage::GoogleXML::GetObjectHttpUrl#get_object_http_url` 
  request

## 1.7.0

### User-facing

#### Added

- \#409 Support query parameters in `Fog::Storage::Google` GET requests [stanhu]
- \#394 Add some helper methods to `Fog::Compute::Google::Server` [temikus]
  - `.private_ip_address`
  - `.stopped?`
- \#375 Add timeout options to `Fog::Storage::GoogleJSON` client [dosuken123]

#### Changed

- \#394 `save/update/destroy` and other operations now wait until they are in a 
  DONE state, instead of !PENDING. This should be a no-op for users but should 
  safeguard from issues in the future. [temikus]
- \#383 `Fog::Compute::Google::Address` resources are now created synchronously
  by default. [temikus]

### Development changes

#### Added

- \#409 Expand `Fog::Storage::Google` unit tests [stanhu]
- \#370 Introducing test coverage back, integrating with codecov.io [temikus]
- \#373 Increase integration test coverage. [temikus]
  - Add Firewall factory and tests.
  - Add InstanceGroup factory and tests.
  - Add MachineType tests.
- \#376 Add doc coverage tracking. [temikus]
- \#383 Increase integration test coverage further. [temikus]
  - Add collection tests and factories (when mutable) for following resources:
    - Addresses 
    - Disks
    - Projects
    - Routes
    - Operations
    - Networks
    - Subnetworks
  - Fix compute tests Rake task.
  - Remove old tests and helpers for Disk, Addresses and Networks.
- \#394 Improve `Server` model test coverage + miscellaneous improvements. [temikus]
  - Add source_image parameter to `DiskFactory` so the Servers factory creates
    properly running instances.
  - `CollectionFactory.cleanup` method is now cleaning up resources per-suite
    instead of using a global prefix.
  - Add new test formatter improving observability of CI logs.
  - Add debug logs to test.
  - Improve doc coverage.

## 1.6.0

### User-facing

#### Changed

- \#338 `Fog::Google::SQL` resources are now created and destroyed synchronously by default. 
You can override it in a standard manner by passing a parameter to async method, e.g.:
 `Fog::Google::SQL::Instance.create(true)` [temikus]
- \#367 `Fog::Compute::Google::Server.bootstrap` changes [temikus]
  - Now creates instances with disks that automatically delete on instance shutdown.
  - Now creates instances with a public IP address by default.

#### Added

- \#361 `Fog::Compute::Google::Server` now recognises `network_ip` attribute to specify internal IP. [mattimatti]

#### Fixed

- \#338 Fixed SQL Users model workflow [temikus]
- \#359 Fix whitespace escaping in XML Storage methods [temikus]
- \#366 Fixing `Server` model to properly accept `:private_key_path` and `:public_key_path` attributes again. [temikus]
- \#367 `Fog::Compute::Google::Server.bootstrap` parameters are now properly merged with default ones. [tesmikus]

### Development changes

#### Added

- \#338 Major refactor of SQLv1 and SQLv2 tests + a lot of small test fixes/improvements
   (see PR/commit messages for full set of changes) [temikus]

#### Fixed

- \#363 Fixed flaky Monitoring tests [temikus]

## 1.5.0

### User-facing

- \#348 Added Instance Group Manager and Instance Templates [bpaquet]

  - `Fog::Compute::Google::InstanceGroupManager` model and associated requests:
    - `:get_instance_group_manager`
    - `:insert_instance_group_manager`
    - `:delete_instance_group_manager`
    - `:list_instance_group_managers`
    - `:list_aggregated_instance_group_managers`
    - `:recreate_instances`
    - `:abandon_instances`

  - `Fog::Compute::Google::InstanceTemplate` model and associated requests:
    - `:list_instance_templates`
    - `:get_instance_template`
    - `:insert_instance_template`
    - `:delete_instance_template`
    - `:set_instance_template`

#### Fixed

- \#356 Hotfix - removing buggy deprecated 'google-containers' project, causing 403 errors
  on `images.all` call. [tumido]

### Development changes

#### Added

- \#350 Added InstanceGroupManager and InstanceTemplate integration tests [temikus]

## 1.4.0

### User-facing

#### Added

- \#336 `Fog::Compute::Google::Server.set_metadata` is now working properly and adopted a simpler format, e.g. `{'foo' => 'bar', 'baz'=>'foo'}`
- \#334 Added a new helper method: `Fog::Compute::Google::Server.public_ip_address` [temikus] 
- \#314 Added `Fog::Compute::Google::InstanceGroup.add_instance` method back [temikus] 
- \#326 Added support for using predefined ACLs, refactor valid ACLs [vimutter]
- \#318 Added fog_public support in Storage JSON API [jayhsu21]

#### Fixed

- \#354 Bump Google API client to 0.23 [temikus] 
- \#346 Fixed get_health when called with an instance name [bpaquet] 
- \#317 Fixed source_image selection to get the image from name if the format is not compatible with new Google API Client [temikus] 
- \#321 Fix string key instead of symbol for subnetworks listing [tumido] 
- \#351 Fixed trailing spaces and added data presence check to `Fog::Storage::GoogleJSON.put_object` [vimutter] 

### Development changes

#### Added

- \#353 Added collection/model unit tests to be run by Travis CI [temikus] 
- \#347 Added target pool tests [temikus] 

#### Fixed

- \#322 Fixed all broken integration tests, all tests now pass in CI [temikus]
- \#344 Updated CI pipeline to run in parallel, broke out test tasks [temikus] 

## 1.0.1

\#290 - Fixes paperclip integration
\#288 - Fixes typo in server network code

## 1.0.0

1.0.0!!!!!!!!!!!!

This rewrites everything except for the legacy storage backend!

Shoutout to @emilymye, @Temikus, @DawidJanczak, @Everlag and everyone who has been asking for this for ~forever.

We did this major refactor because as of version 0.9, google-api-client rewrote their entire api, thus limiting our ability to integrate with google APIs, and also running into a bunch of deprecated gem collisions.

You no longer need to require google-api-client, we are now doing that for you.

HELP: We need help testing. Please report bugs! As this is a complete rewrite of the request layer, there are undoubetedly bugs. We had to throw away most of our tests, and due to the time this has taken us, we chose to ship, instead of writing tests for everything all over again. If you would like to write tests, we would love your PRs, as well as any ideas you have about how we can test this code better.

Thanks!

## 0.6.0

NOTE: New Monitoring models are not compatible in any way to old ones because of significant rewrite to monitoring api since v2beta2.

## 0.5.5

Adds support for SSL certificates, https proxies and global IP addresses: #244

## 0.5.4

Fixes a storage bug #224 and fixes an issue with compute snapshots #240

## 0.5.3

Fixes a bunch of bugs and adds subnetworks support.

PRs that change functionality: #212, #215, #203, #198, #201, #221, #222, #216

## 0.5.2

Rapid-releasing 0.5.2 due to regression fixed by #190 still present in v0.5.1
We encourage people using 0.5.1 to upgrade.

## Template to use

## Next release

### User-facing

#### Changed

#### Added

#### Fixed

### Development changes

#### Added

#### Fixed