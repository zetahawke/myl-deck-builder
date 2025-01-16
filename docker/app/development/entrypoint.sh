#!/bin/bash -e

# Enable jemalloc for reduced memory usage and latency.
if [ -z "${LD_PRELOAD+x}" ]; then
    LD_PRELOAD=$(find /usr/lib -name libjemalloc.so.2 -print -quit)
    export LD_PRELOAD
fi

# Remove a potentially pre-existing server.pid for Rails.
if [ -f tmp/pids/server.pid ]; then
  rm -f /chv_transvip/tmp/pids/server.pid
fi

if [ "${@: -2:1}" = "./bin/dev" ]; then
  ./bin/bundle install
  ./bin/rails db:create
  ./bin/rails db:prepare
  yarn install
  yarn build:css
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
# bundle exec puma -e development -C config/puma.rb
exec "$@"