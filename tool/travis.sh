#!/bin/bash

pub get --packages-dir
pub run test
pub run dart_codecov_generator --no-html --verbose test/unit/
bash <(curl -s https://codecov.io/bash)