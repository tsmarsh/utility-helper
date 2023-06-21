#!/bin/sh
# wait-for-services.sh

set -e

hostnames="$1"
port=$2
shift 2
cmd="$@"

for hostname in $(echo "$hostnames" | tr ',' ' '); do
    echo "Waiting for $hostname:$port to be available..."
    while ! nc -z "$hostname" "$port"; do
        sleep 1
    done
    echo "$hostname:$port is available"
done

exec $cmd
