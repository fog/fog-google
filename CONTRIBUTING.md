# Getting Involved

New contributors are always welcome, and when in doubt please ask questions! We strive to be an open and welcoming community. Please be nice to one another.

### Coding

* Pick a task:
  * Offer feedback on open [pull requests](https://github.com/fog/fog-google/pulls).
  * Review open [issues](https://github.com/fog/fog-google/issues) for things to help on.
  * [Create an issue](https://github.com/fog/fog-google/issues/new) to start a discussion on additions or features.
* Fork the project, add your changes and tests to cover them in a topic branch.
* Commit your changes and rebase against `fog/fog-google` to ensure everything is up to date.
* [Submit a pull request](https://github.com/fog/fog-google/compare/)

### Non-Coding

* Offer feedback on open [issues](https://github.com/fog/fog-google/issues).
* Organize or volunteer at events.

I recommend heading over to fog's [CONTRIBUTING](https://github.com/fog/fog/blob/master/CONTRIBUTING.md) and having a look around as well.  It has information and context about the state of the `fog` project as a whole.

## Contributing Code

This document is very much a work in progress.  Sorry about that.

### Testing

We're in the middle of switching from using `shindo` to `minitest` as our testing framework.  Right now, the `shindo` tests in `test/` work in mocking mode, but don't work when mocking is turned off.  To start, we'll only be writing live integration tests in our `minitest` suite, and we'll hopefully flesh out mocks later down the line, (perhaps when a more stable mocking framework for the whole `fog` ecosystem is worked out; for example, see [fog/fog#1252](https://github.com/fog/fog/issues/1252)).

If you'd like to run live integration tests for `Fog::Compute`, you need a `:test` configuration in `~/.fog`.  Something like:

```
test:
  google_project: my-project
  google_client_email: xxxxxxxxxxxxx-xxxxxxxxxxxxx@developer.gserviceaccount.com
  google_key_location: /path/to/my-project-xxxxxxxxxxxxx.p12
  google_json_key_location: /path/to/my-project-xxxxxxxxxxxxx.json
```
