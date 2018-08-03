# Fog::Google

[![Gem Version](https://badge.fury.io/rb/fog-google.svg)](http://badge.fury.io/rb/fog-google) [![Build Status](https://travis-ci.org/fog/fog-google.svg?branch=master)](https://travis-ci.org/fog/fog-google) [![codecov](https://codecov.io/gh/fog/fog-google/branch/master/graph/badge.svg)](https://codecov.io/gh/fog/fog-google) [![Doc coverage](https://inch-ci.org/github/fog/fog-google.svg?branch=master)](https://inch-ci.org/github/fog/fog-google)

The main maintainers for the Google sections are @icco, @Temikus and @plribeiro3000. Please send pull requests to them.

## Important notices

- As of **v1.0.0**, fog-google includes google-api-client as a dependency, there is no need to include it separately anymore.

- Fog-google is currently supported on Ruby 2.3+ See [supported ruby versions](#supported-ruby-versions) for more info.

See **[MIGRATING.md](MIGRATING.md)** for migration between major versions.

## Storage

There are two ways to access [Google Cloud Storage](https://cloud.google.com/storage/). The old S3 API and the new JSON API. `Fog::Storage::Google` will automatically direct you to the appropriate API based on the credentials you provide it.

 * The [XML API](https://cloud.google.com/storage/docs/xml-api-overview/) is almost identical to S3. Use [Google's interoperability keys](https://cloud.google.com/storage/docs/migrating#keys) to access it.
 * The new [JSON API](https://cloud.google.com/storage/docs/json_api/) is faster and uses auth similarly to the rest of the Google Cloud APIs using a [service account private key](https://developers.google.com/identity/protocols/OAuth2ServiceAccount).

## Compute

Google Compute Engine is a Virtual Machine hosting service. Currently it is built on version [v1](https://cloud.google.com/compute/docs/reference/v1/) of the GCE API.

As of 2017-12-15, we are still working on making Fog for Google Compute engine (`Fog::Compute::Google`) feature complete. If you are using Fog to interact with GCE, please keep Fog up to date and [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like.

## SQL

Fog implements [v1beta4](https://cloud.google.com/sql/docs/mysql/admin-api/v1beta4/) of the Google Cloud SQL Admin API. As of 2017-11-06, Cloud SQL is mostly feature-complete. Please [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like as we finish 
adding remaining features. 

## DNS

Fog implements [v1](https://cloud.google.com/dns/api/v1/) of the Google Cloud DNS API. We are always looking for people to improve our code and test coverage, so please [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like.

## Monitoring

Fog implements [v3](https://cloud.google.com/monitoring/api/v3/) of the Google Cloud Monitoring API. As of 2017-10-05, we believe Fog for Google Cloud Monitoring is feature complete for metric-related resources and are working on supporting groups. 
 
We are always looking for people to improve our code and test coverage, so please [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like.

## Pubsub

Note: You **must** have a version of google-api-client > 0.8.5 to use the Pub/Sub API; previous versions will not work.

Fog mostly implements [v1](https://cloud.google.com/pubsub/docs/reference/rest/) of the Google Cloud Pub/Sub API; however some less common API methods are missing. Pull requests for additions would be greatly appreciated.

## Installation

Add the following two lines to your application's `Gemfile`:

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

## Testing

Integration tests can be kicked off via following rake tasks.
**Important note:** As those tests are running against real API's YOU WILL BE BILLED.

```
rake test               # Run all integration tests
rake test:parallel      # Run all integration tests in parallel

rake test:compute       # Run Compute API tests
rake test:monitoring    # Run Monitoring API tests
rake test:pubsub        # Run PubSub API tests
rake test:sql           # Run SQL API tests
rake test:storage       # Run Storage API tests
```

Since some resources can be expensive to test, we have a self-hosted CI server.
Due to security considerations a repo maintainer needs to add the label `integrate` to kick off the CI.

## Setup

#### Credentials

Follow the [instructions to generate a private key](https://cloud.google.com/storage/docs/authentication#generating-a-private-key). A sample credentials file can be found in `.fog.example` in this directory:

```
cat .fog.example >> ~/.fog # appends the sample configuration
vim ~/.fog                 # edit file with yout config
```

#### SSH-ing into instances

If you want to be able to bootstrap SSH-able instances, (using `servers.bootstrap`,) be sure you have a key in `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

## Quickstart

Once you've specified your credentials, you should be good to go!
```
$ bundle exec pry
[1] pry(main)> require 'fog/google'
=> true
[2] pry(main)> connection = Fog::Compute::Google.new
[3] pry(main)> connection.servers
=> [  <Fog::Compute::Google::Server
    name="xxxxxxx",
    kind="compute#instance",
```

## Supported Ruby Versions

Fog-google is currently supported on Ruby 2.3+.

In general we support (and run our CI) for Ruby versions that are actively supported
by Ruby Core - that is, Ruby versions that are not end of life. Older versions of 
Ruby _may_ still work, but are unsupported and not recommended. See https://www.ruby-lang.org/en/downloads/branches/
for details about the Ruby support schedule.

## Contributing

See `CONTRIBUTING.md` in this repository.
