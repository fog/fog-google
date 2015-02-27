# fog-google

Fog-Google is a repository for holding Google related services for [Fog](https://github.com/fog/fog).

This repository is still an in-progress work.

Fog currently supports two Google Cloud services: [Google Compute Engine](https://cloud.google.com/compute/) and [Google Cloud Storage](https://cloud.google.com/storage/). The main maintainer for the Google sections is @icco.

## Storage

Google Cloud Storage originally was very similar to Amazon's S3. Because of this, Fog implements the [XML GCS API](https://cloud.google.com/storage/docs/xml-api-overview). We eventually want to move to the new [JSON API](https://cloud.google.com/storage/docs/json_api/), once it has similar performance characteristics to the XML API. If this migration interests you, send us a pull request!

## Compute

Google Compute Engine is a Virtual Machine hosting service. Currently it is built on version [v1](https://cloud.google.com/compute/docs/reference/v1/) of the GCE API.

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

Thanks!
