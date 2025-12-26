#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:clobber
SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile
bundle exec rake assets:clean
