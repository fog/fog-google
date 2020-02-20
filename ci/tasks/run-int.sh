#!/usr/bin/env bash

set -e

my_dir="$( cd $(dirname $0) && pwd )"
release_dir="$( cd ${my_dir} && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd ../../../.. && pwd )"

pushd ${release_dir} > /dev/null

source ci/tasks/utils.sh

popd > /dev/null

check_param google_project
check_param google_json_key_data
check_param rake_task
check_param codecov_token

echo $google_json_key_data > `pwd`/service_account_key.json

cat >~/.fog <<EOL
test:
  google_project: ${google_project}
  google_json_key_location: `pwd`/service_account_key.json
EOL

pushd ${release_dir} > /dev/null

echo "Ruby version:"
ruby --version

echo "Bundler version:"
bundler --version

echo "Exporting bundler options..."

# Setting via local config options as BUNDLE_PATH appears to not work
# see https://github.com/rails/spring/issues/339
bundle config --local path ../../bundle
bundle config --local bin ../../bundle/bin

echo "Checking dependencies..."
# Check if dependencies are satisfied, otherwise kick off bundle install
bundle check || bundle install --jobs=3 --retry=3

echo "Dependencies resolved to:"
bundle list

echo "Starting test run..."
FOG_MOCK=false COVERAGE=true CODECOV_TOKEN=${codecov_token} rake ${rake_task}

popd > /dev/null