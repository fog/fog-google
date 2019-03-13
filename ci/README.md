# fog-google CI

This pipeline performs integration tests against every PR with the
`integrate` label. This allows whitelisted PRs to be tested
automatically before being merged. Status is updated on the
PR when the test completes.

## Setup

In order to run the fog-google Concourse Pipeline you must have an existing
[Concourse](http://concourse.ci) environment.

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
fly -t fog-ci set-pipeline -p pr-integration -c pipeline.yml -l credentials.yml
```

* Unpause the fog-google pipeline:

```
fly -t fog-ci unpause-pipeline -p pr-integration
```

## Credentials Requirements

Several external pieces of authentication are needed for credentials.yml

1. A JSON Service Account File for a service account with at least Editor access to the project.
    * To get a Service Account File, see [here](https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount)
      and create using the Project/Editor role.

1. A [Github Access Token](https://github.com/blog/1509-personal-api-tokens) with at least
`repo:status` access and a private key with push access to the `fog/fog-google` repositoy.

1. A [Codecov.io](https://codecov.io/) token for tracking test coverage.

These items are equivalent to your login credentials for their resources.

## Login Gotchas

* Our concourse pipeline is using GitHub auth, providing access to manipulate the pipeline to the members of the [fog-google team](https://github.com/orgs/fog/teams/fog-google), managed through the OAuth application managed by [fog-google bot](https://github.com/fog-google-bot).

* If logging into a specific team, ie `fog-google`, use `--team-name fog-google` to specify that.

## Dockerfile

The [docker-image](https://github.com/fog/fog-google/blob/master/ci/docker-image) directory contains
the Dockerfile necessary for recreating the Docker image used in tasks. This is referenced
in a per-task basis as `image_resource`, ie in
image_resource [run-int.yml](https://github.com/fog/fog-google/blob/master/ci/tasks/run-int.yml)