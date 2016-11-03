# Fog::Google

[![Gem Version](https://badge.fury.io/rb/fog-google.svg)](http://badge.fury.io/rb/fog-google) [![Build Status](https://travis-ci.org/fog/fog-google.svg?branch=master)](https://travis-ci.org/fog/fog-google) [![Dependency Status](https://gemnasium.com/fog/fog-google.svg)](https://gemnasium.com/fog/fog-google) [![Coverage Status](https://img.shields.io/coveralls/fog/fog-google.svg)](https://coveralls.io/r/fog/fog-google) [![Code Climate](https://codeclimate.com/github/fog/fog-google.png)](https://codeclimate.com/github/fog/fog-google) [![Stories in Ready](https://badge.waffle.io/fog/fog-google.png?label=ready&title=Ready)](https://waffle.io/fog/fog-google)

The main maintainers for the Google sections are @icco, @Temikus and @plribeiro3000. Please send pull requests to them.

**As of v0.1.1, Google no longer supports Ruby versions less than 2.0.0.**

**Currently, `fog-google` does not support versions of `google-api-client` >= 0.9 or <= 0.8.5.**


## Storage

There are two ways to access [Google Cloud Storage](https://cloud.google.com/storage/). The old S3 API and the new JSON API. `Fog::Storage::Google` will automatically direct you to the appropriate API based on the credentials you provide it.

 * The [XML API](https://developers.google.com/storage/docs/xml-api-overview) is almost identical to S3. Use [Google's interoperability keys](https://cloud.google.com/storage/docs/migrating#keys) to access it.
 * The new [JSON API](https://developers.google.com/storage/docs/json_api/) is faster and uses auth similarly to the rest of the Google Cloud APIs using a [service account private key](https://developers.google.com/identity/protocols/OAuth2ServiceAccount).

## Compute

Google Compute Engine is a Virtual Machine hosting service. Currently it is built on version [v1](https://developers.google.com/compute/docs/reference/v1/) of the GCE API.

As of 2015-12-07, we believe Fog for Google Compute engine (`Fog::Compute::Google`) is feature complete.

If you are using Fog to interact with GCE, please keep Fog up to date and [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like.

## SQL

Fog implements [v1beta3](https://cloud.google.com/sql/docs/admin-api/v1beta3/) of the Google Cloud SQL Admin API. This is a currently deprecated API. Pull Requests for updates would be greatly appreciated.

## DNS

Fog implements [v1](https://cloud.google.com/dns/api/v1/) of the Google Cloud DNS API. We are always looking for people to improve our code and test coverage, so please [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like.

## Monitoring

Fog implements [v2beta2](https://cloud.google.com/monitoring/v2beta2/) of the Google Cloud Monitoring API. As of 2016-03-15, we believe Fog for Google Cloud Monitoring is feature complete. We are always looking for people to improve our code and test coverage, so please [file issues](https://github.com/fog/fog-google/issues) for any anomalies you see or features you would like.

## Pubsub

Note: You **must** have a version of google-api-client > 0.8.5 to use the Pub/Sub API; previous versions will not work.

Fog mostly implements [v1](https://cloud.google.com/pubsub/reference/rest/) of the Google Cloud Pub/Sub API; however some less common API methods are missing. Pull requests for additions would be greatly appreciated.
 
## Installation

Add the following two lines to your application's `Gemfile`:

```ruby
gem 'fog-google'
gem 'google-api-client', '~> 0.8.6'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install fog-google
```

## Setup

#### Credentials

Follow the [instructions to generate a private key](https://cloud.google.com/storage/docs/authentication#generating-a-private-key).  You can then create a fog credentials file at `~/.fog`, which will look something like this:

```
my_credential:
    google_project: my-project
    google_client_email: xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx@developer.gserviceaccount.com
    google_json_key_location: /path/to/my-project-xxxxxxxxxxxx.json
```

You can also provide service account credentials with `google_json_key_string` or with `google_key_location` and `google_key_string` for P12 private keys.

HMAC credentials follow a similar format:

```
my_credentials:
	google_storage_access_key_id: GOOGXXXXXXXXXXXXXXXX
	google_storage_secret_access_key: XXXX+XXX/XXXXXXXX+XXXXXXXXXXXXXXXXXXXXX
```	

#### SSH-ing into instances

If you want to be able to bootstrap SSH-able instances, (using `servers.bootstrap`,) be sure you have a key in `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

## Quickstart

Once you've specified your credentials, you should be good to go!
```
λ bundle exec pry
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
