# fog-google CI

This pipeline performs integration tests against every PR with the
`integrate` label. This allows whitelisted PRs to be tested
automatically before being merged. Status is updated on the
PR when the test completes.

## Setup

In order to run the fog-google Concourse Pipeline you must have an existing
[Concourse](http://concourse.ci) environment.
See [Deploying Concourse on Google Compute Engine](https://github.com/cloudfoundry-incubator/bosh-google-cpi-release/blob/master/docs/concourse/README.md)
for instructions.

To deploy the pipeline:

* Download the `fly` binary from the Concourse web interface and place it in your `$PATH`.

* Login to your Concourse:

```
fly -t fog-ci login -c <YOUR CONCOURSE URL>
```

* Update the [credentials.yml](https://github.com/fog/fog-google/blob/master/ci/credentials.yml.tpl)
file. See [Credentials Requirements](#credentials-requirements) for specific instructions.

* Set the fog-google pipeline:

```
fly -t fog-ci set-pipeline -p fog-google -c pipeline.yml -l credentials.yml
```

* Unpause the fog-google pipeline:

```
fly -t fog-ci unpause-pipeline -p fog-google
```

## Credentials Requirements

Several external pieces of authentication are needed for credentials.yml

1. A JSON Service Account File for a service account with at least Editor access to the project.
    * To get a Service Account File, see [here](https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount) 
      and create using the Project/Editor role.

1. A [Github Access Token](https://github.com/blog/1509-personal-api-tokens) with at least
`repo:status` access and a private key with push access to the `fog/fog-google` repositoy.

These items are equivalent to your login credentials for their resources.

## Login Gotchas

* If your Concourse deployment is using a self-signed certificate, use `--insecure` to
trust the provided certificate.

* If logging into a specific team, ie `fog-google`, use `--team-name fog-google` to specify that.

## Dockerfile

The [docker-image](https://github.com/fog/fog-google/blob/master/ci/docker-image) directory contains
the Dockerfile necessary for recreating the Docker image used in tasks. This is referenced
in a per-task basis as `image_resource`, ie in
image_resource [run-int.yml](https://github.com/fog/fog-google/blob/master/ci/tasks/run-int.yml)