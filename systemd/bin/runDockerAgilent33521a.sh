#!/usr/bin/env bash

set -u

if [ -z "$AGILENT33521A_INSTANCE" ]; then
    echo "AGILENT33521A_INSTANCE environment variable is not set." >&2
    exit 1
fi

export AGILENT33521A_CURRENT_PV_AREA_PREFIX=AGILENT33521A_${AGILENT33521A_INSTANCE}_PV_AREA_PREFIX
export AGILENT33521A_CURRENT_PV_DEVICE_PREFIX=AGILENT33521A_${AGILENT33521A_INSTANCE}_PV_DEVICE_PREFIX
export AGILENT33521A_CURRENT_DEVICE_IP=AGILENT33521A_${AGILENT33521A_INSTANCE}_DEVICE_IP
export AGILENT33521A_CURRENT_DEVICE_PORT=AGILENT33521A_${AGILENT33521A_INSTANCE}_DEVICE_PORT
export AGILENT33521A_CURRENT_TELNET_PORT=AGILENT33521A_${AGILENT33521A_INSTANCE}_TELNET_PORT
# Only works with bash
export EPICS_PV_AREA_PREFIX=${!AGILENT33521A_CURRENT_PV_AREA_PREFIX}
export EPICS_PV_DEVICE_PREFIX=${!AGILENT33521A_CURRENT_PV_DEVICE_PREFIX}
export EPICS_DEVICE_IP=${!AGILENT33521A_CURRENT_DEVICE_IP}
export EPICS_DEVICE_PORT=${!AGILENT33521A_CURRENT_DEVICE_PORT}
export EPICS_TELNET_PORT=${!AGILENT33521A_CURRENT_TELNET_PORT}

# Create volume for autosave and ignore errors
/usr/bin/docker create \
    -v /opt/epics/startup/ioc/agilent33521a-epics-ioc/iocBoot/iocagilent33521a/autosave \
    --name agilent33521a-epics-ioc-${AGILENT33521A_INSTANCE}-volume \
    lnlsdig/agilent33521a-epics-ioc:${IMAGE_VERSION} \
    2>/dev/null || true

# Remove a possible old and stopped container with
# the same name
/usr/bin/docker rm \
    agilent33521a-epics-ioc-${AGILENT33521A_INSTANCE} || true

/usr/bin/docker run \
    --net host \
    -t \
    --rm \
    --volumes-from agilent33521a-epics-ioc-${AGILENT33521A_INSTANCE}-volume \
    --name agilent33521a-epics-ioc-${AGILENT33521A_INSTANCE} \
    lnlsdig/agilent33521a-epics-ioc:${IMAGE_VERSION} \
    -t "${EPICS_TELNET_PORT}" \
    -i "${EPICS_DEVICE_IP}" \
    -p "${EPICS_DEVICE_PORT}" \
    -P "${EPICS_PV_AREA_PREFIX}" \
    -R "${EPICS_PV_DEVICE_PREFIX}" \
