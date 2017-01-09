#!/bin/bash

pub get --packages-dir

# Fast fail the script on failures.
set -e

# Run the tests.
pub run test test/unit/
# pub run test -p content-shell test/browser/

# If the COVERALLS_TOKEN token is set on travis
# Install dart_coveralls
# Rerun tests with coverage and send to coveralls
if [ "$COVERALLS_TOKEN" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/test_all.dart
fi