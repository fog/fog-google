#! /bin/bash
#
# For all git tags, generate a gem and check its sha256 sum.

for ver in $(git tag); do
  git checkout $ver
  sleep 1
  rake build
  sleep 1
  shasum -a 256 pkg/fog-google-$ver.gem
done

git checkout master

shasum -a 256 pkg/*
