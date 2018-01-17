#!/usr/bin/env bash

set -u

if [ -z "$AGILENT33521A_INSTANCE" ]; then
    echo "AGILENT33521A_INSTANCE environment variable is not set." >&2
    exit 1
fi

/usr/bin/docker stop \
    agilent33521a-epics-ioc-${AGILENT33521A_INSTANCE}
