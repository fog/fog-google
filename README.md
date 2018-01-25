# Fog::Google

[![Gem Version](https://badge.fury.io/rb/fog-google.svg)](http://badge.fury.io/rb/fog-google) [![Build Status](https://travis-ci.org/fog/fog-google.svg?branch=master)](https://travis-ci.org/fog/fog-google) [![Dependency Status](https://gemnasium.com/fog/fog-google.svg)](https://gemnasium.com/fog/fog-google) [![Coverage Status](https://img.shields.io/coveralls/fog/fog-google.svg)](https://coveralls.io/r/fog/fog-google) [![Code Climate](https://codeclimate.com/github/fog/fog-google.png)](https://codeclimate.com/github/fog/fog-google)

The main maintainers for the Google sections are @icco, @Temikus and @plribeiro3000. Please send pull requests to them.

**As of v0.1.1, Google no longer supports Ruby versions less than 2.0.0.**

**As of v1.0.0, fog-google includes google-api-client as a dependency**


## Storage

There are two ways to access [Google Cloud Storage](https://cloud.google.com/storage/). The old S3 API and the new JSON API. `Fog::Storage::Google` will automatically direct you to the appropriate API based on the credentials you provide it.

 * The [XML API](https://developers.google.com/storage/docs/xml-api-overview) is almost identical to S3. Use [Google's interoperability keys](https://cloud.google.com/storage/docs/migrating#keys) to access it.
 * The new [JSON API](https://developers.google.com/storage/docs/json_api/) is faster and uses auth similarly to the rest of the Google Cloud APIs using a [service account private key](https://developers.google.com/identity/protocols/OAuth2ServiceAccount).

## Compute

Google Compute Engine is a Virtual Machine hosting service. Currently it is built on version [v1](https://developers.google.com/compute/docs/reference/v1/) of the GCE API.

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

Fog mostly implements [v1](https://cloud.google.com/pubsub/reference/rest/) of the Google Cloud Pub/Sub API; however some less common API methods are missing. Pull requests for additions would be greatly appreciated.

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

The tests in `tests` are deprecated. We are currently working on a migration of tests to `minitest`.

For your test to be tested with real credentials, a repo maintainer may add the label `integrate` to your PR to run integration tests.

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

## Contributing

See `CONTRIBUTING.md` in this repository.
