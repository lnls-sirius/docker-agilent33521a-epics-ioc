FROM lnlsdig/epics-stream_2_7_7

RUN git clone https://github.com/lnls-dig/agilent33521a-epics-ioc.git /opt/epics/agilent33521a && \
    cd /opt/epics/agilent33521a && \
    git checkout e67c587993cf83bb90d25be9781ce00a29cc18db && \
    echo 'EPICS_BASE=/opt/epics/base' > configure/RELEASE.local && \
    echo 'SUPPORT=/opt/epics/synApps_5_8/support' >> configure/RELEASE.local && \
    echo 'ASYN=$(SUPPORT)/asyn-4-26' >> configure/RELEASE.local && \
    echo 'STREAM=/opt/epics/stream' >> configure/RELEASE.local && \
    make install

WORKDIR /opt/epics/agilent33521a/iocBoot/iocagilent33521a

ENTRYPOINT ["/opt/epics/agilent33521a/iocBoot/iocagilent33521a/run.sh"]
