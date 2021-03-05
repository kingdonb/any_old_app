#!/bin/bash
set -e
rm -f /any_old_app/tmp/pids/server.pid
exec "$@"
