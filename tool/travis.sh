#!/bin/bash

pub get --packages-dir
pub run test test/unit/
pub run test -p content-shell test/browser/
pub run dart_codecov_generator --no-html --verbose test/unit/
bash <(curl -s https://codecov.io/bash)