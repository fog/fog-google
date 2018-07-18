#!/usr/bin/env bash

set -e

my_dir="$( cd $(dirname $0) && pwd )"
release_dir="$( cd ${my_dir} && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd ../../../.. && pwd )"

pushd ${release_dir} > /dev/null

source ci/tasks/utils.sh

popd > /dev/null

check_param google_project
check_param google_client_email
check_param google_json_key_data
check_param rake_task
check_param codecov_token

echo $google_json_key_data > `pwd`/service_account_key.json

cat >~/.fog <<EOL
test:
  google_project: ${google_project}
  google_client_email: ${google_client_email}
  google_json_key_location: `pwd`/service_account_key.json
EOL

pushd ${release_dir} > /dev/null

bundle install --jobs=3 --retry=3

FOG_MOCK=false COVERAGE=true CODECOV_TOKEN=${codecov_token} rake ${rake_task}

popd > /dev/null