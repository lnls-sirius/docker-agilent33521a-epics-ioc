ARG DEBIAN_VERSION
FROM lnls/epics-synapps:base-3.15-synapps-lnls-R1-0-0-${DEBIAN_VERSION}

ARG COMMIT
ARG DEBIAN_VERSION
ARG IOC_GROUP
ARG IOC_REPO

ENV BOOT_DIR iocagilent33521a

RUN git clone \
        https://github.com/${IOC_GROUP}/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${COMMIT} && \
    sed -i -e 's|^EPICS_BASE=.*$|EPICS_BASE=/opt/epics/base|' configure/RELEASE && \
    sed -i -e 's|^SUPPORT=.*$|SUPPORT=/opt/epics/synApps-lnls-R1-0-0/support|' configure/RELEASE && \
    sed -i -e 's|^STREAM=.*$|STREAM=$(SUPPORT)/stream-R2-7-7|' configure/RELEASE && \
    sed -i -e 's|^AUTOSAVE=.*$|AUTOSAVE=$(SUPPORT)/autosave-R5-9|' configure/RELEASE && \
    make && \
    make install && \
    make clean

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
