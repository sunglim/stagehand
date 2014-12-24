#!/bin/bash

# Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
# All rights reserved. Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Get the Dart SDK.
DART_DIST=dartsdk-linux-x64-release.zip
curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/$DART_DIST > $DART_DIST
unzip $DART_DIST > /dev/null
rm $DART_DIST
export DART_SDK="$PWD/dart-sdk"
export PATH="$DART_SDK/bin:$PATH"

# Display installed versions.
dart --version

# Globally install grinder.
pub global activate grinder
pub global activate test_runner
export PATH=~/.pub-cache/bin:$PATH

# Get our packages.
pub get

# Verify that the libraries are error free.
dartanalyzer --fatal-warnings \
  bin/stagehand.dart \
  lib/stagehand.dart \
  test/all_test.dart

# Run the tests.
dart test/all_test.dart

# Get the Dart SDK.
DART_CONTENT_SHELL=content_shell-linux-x64-release.zip
curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/dartium/content_shell-linux-x64-release.zip > $DART_CONTENT_SHELL
unzip $DART_CONTENT_SHELL > /dev/null
rm $DART_CONTENT_SHELL

run_tests --content-shell-bin ./drt-lucid64-full-stable-42039.0/content_shell test/all_test.dart

# Run all the generators and analyze the generated code.
grind test
