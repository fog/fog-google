# Fog::Google

[![Gem Version](https://badge.fury.io/rb/fog-google.svg)](http://badge.fury.io/rb/fog-google) [![Build Status](https://travis-ci.org/fog/fog-google.svg?branch=master)](https://travis-ci.org/fog/fog-google) [![Dependency Status](https://gemnasium.com/fog/fog-google.svg)](https://gemnasium.com/fog/fog-google) [![Coverage Status](https://img.shields.io/coveralls/fog/fog-google.svg)](https://coveralls.io/r/fog/fog-google) [![Code Climate](https://codeclimate.com/github/fog/fog-google.png)](https://codeclimate.com/github/fog/fog-google) [![Stories in Ready](https://badge.waffle.io/fog/fog-google.png?label=ready&title=Ready)](https://waffle.io/fog/fog-google)

Fog currently supports two Google Cloud services: [Google Compute Engine](https://developers.google.com/compute/) and [Google Cloud Storage](https://developers.google.com/storage/). The main maintainer for the Google sections is @icco.

## Storage

Google Cloud Storage originally was very similar to Amazon's S3. Because of this, Fog implements the [XML GCS API](https://developers.google.com/storage/docs/xml-api-overview). We eventually want to move to the new [JSON API](https://developers.google.com/storage/docs/json_api/), once it has similar performance characteristics to the XML API. If this migration interests you, send us a pull request!

## Compute

Google Compute Engine is a Virtual Machine hosting service. Currently it is built on version [v1](https://developers.google.com/compute/docs/reference/v1/) of the GCE API.

Our implementation of the API currently supports

 * Server creation, deletion and bootstrapping
 * Persistent Disk creation and deletion
 * Image lookup
 * Network and Firewall configuration
 * Operations
 * Snapshots
 * Instance Metadata
 * Project Metadata

Features we are looking forward to implementing in the future:

 * Image creation
 * Load balancer configuration

If you are using Fog to interact with GCE, please keep Fog up to date and [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fog-google'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install fog-google
```

### Setup

#### Credentials

Follow the [instructions to generate a private key](https://cloud.google.com/storage/docs/authentication#generating-a-private-key).  You can then create a fog credentials file at `~/.fog`, which will look something like this:

```
my_credential:
    google_project: my-project
    google_client_email: xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx@developer.gserviceaccount.com
    google_key_location: /path/to/my-project-xxxxxxxxxxxx.p12
    google_json_key_location: /path/to/my-project-xxxxxxxxxxxx.json
```

#### SSH-ing into instances

If you want to be able to bootstrap SSH-able instances, (using `servers.bootstrap`,) be sure you have a key in `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`.

## Contributing

1. Fork it ( https://github.com/fog/fog-google/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

It's worth noting that, if you're looking through the code, and you'd like to know the history of a line, you may not find it in the history of this repository, since most of the code was extracted from [fog/fog].  So, you can look at the history from commit [fog/fog#c596e] backward for more information.

### Testing

This module is tested with [Minitest](https://github.com/seattlerb/minitest).  Right now, the only tests that exist are live integration tests, found in `test/integration/`.  After completing the installation above, (including setting up your credentials and keys,) make sure you have a `:test` credential in `~/.fog`, for example:

```
test:
    google_project: my-project
    google_client_email: xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx@developer.gserviceaccount.com
    google_key_location: /path/to/my-project-xxxxxxxxxxxx.p12
    google_json_key_location: /path/to/my-project-xxxxxxxxxxxx.json
```

Note that you need both a `.p12` and a `.json` key file for all the tests to pass.

Then, you can run the live tests with:

```shell
$ rake test
```

If you'd like to just run one test or test file, use the `TEST`argument:

```shell
$ rake test TEST=test/integration/compute/test_servers.rb
```

The live integration tests for resources, (servers, disks, etc.,) have a few components:

- The `TestCollection` **mixin module** lives in `test/helpers/test_collection.rb` and contains the standard tests to run for all resources, (e.g. `test_lifecycle`).  It also calls `cleanup` on the resource's factory during teardown, to make sure that resources are getting destroyed before the next test run.
- The **factory**, (e.g. `ServersFactory`, in `test/factories/servers_factory.rb`,) automates the creation of resources and/or supplies parameters for explicit creation of resources.  For example, `ServersFactory` initializes a `DisksFactory` to supply disks in order to create servers, and implements the `params` method so that tests can create servers with unique names, correct zones and machine types, and automatically-created disks.  `ServersFactory` inherits the `create` method from `CollectionFactory`, which allows tests to create servers on-demand.
- The **main test**, (e.g. `TestServers`, in `test/integration/compute/test_servers.rb`,) is the test that actually runs.  It mixes in the `TestCollection` module in order to run the tests in that module, it supplies the `setup` method in which it initializes a `ServersFactory`, and it includes any other tests specific to this collection, (e.g. `test_bootstrap_ssh_destroy`).

If you want to create another resource, you should add live integration tests; all you need to do is create a factory in `test/factories/my_resource_factory.rb` and a main test in `test/integration/compute/test_my_resource.rb` that mixes in `TestCollection`.
