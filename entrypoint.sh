#!/bin/bash

# Fix a Rails-specific issue that prevents the server from restarting 
# when a certain server.pid file pre-exists.
# This script will be executed every time the container gets started
set -e

if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

exec "$@"