#!/bin/sh

set -e

echo "Starting cron in foreground."
crond -f -d 8
