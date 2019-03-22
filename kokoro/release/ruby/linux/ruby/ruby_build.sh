#!/bin/bash

set -ex

# Build protoc
if test ! -e src/protoc; then
  ./autogen.sh
  ./configure
  make -j4
fi

umask 0022
pushd ruby

bundle install && bundle exec rake gem:native
ls pkg
mv pkg/* $ARTIFACT_DIR

# JRuby
rvm use jruby
rake build && gem build google-protobuf.gemspec
mv google-protobuf-*-java.gem $ARTIFACT_DIR

popd
