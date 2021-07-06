ARG BASE_VERSION
ARG COMMIT_
ARG DEBIAN_VERSION
ARG IOC_GROUP
ARG IOC_REPO
ARG SYNAPPS_VERSION

FROM lnls/epics-synapps:${BASE_VERSION}-${SYNAPPS_VERSION}-${DEBIAN_VERSION}

ARG BASE_VERSION
ARG COMMIT_
ARG DEBIAN_VERSION
ARG IOC_GROUP
ARG IOC_REPO
ARG SYNAPPS_VERSION

ENV BOOT_DIR iocagilent33521a
RUN git clone https://github.com/${IOC_GROUP}/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    ln --verbose --symbolic $(ls --directory /opt/epics/synApps*) /opt/epics/synApps && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${COMMIT_} && \
    sed -i -e 's|^EPICS_BASE=.*$|EPICS_BASE=/opt/epics/base|' configure/RELEASE && \
    sed -i -e 's|^SUPPORT=.*$|SUPPORT=/opt/epics/synApps/support|' configure/RELEASE && \
    sed -i -e 's|^STREAM=.*$|STREAM=$(SUPPORT)/stream-R2-7-7|' configure/RELEASE && \
    sed -i -e 's|^AUTOSAVE=.*$|AUTOSAVE=$(SUPPORT)/autosave-R5-9|' configure/RELEASE && \
    make -j$(nproc) && \
    make install && \
    make clean

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
