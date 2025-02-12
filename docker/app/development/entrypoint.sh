#!/bin/sh

set -e

# If running the rails server then create or migrate existing database
if [ "${@: -2:1}" == "./bin/dev" ]]; then
  ./bin/rails db:create
  ./bin/rails db:prepare
fi

# Remove a potentially pre-existing server.pid for Rails.
if [ -f tmp/pids/server.pid ]; then
  rm -f /chv_transvip/tmp/pids/server.pid
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
# bundle exec puma -e development -C config/puma.rb
exec "$@"