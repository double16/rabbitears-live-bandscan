FROM ubuntu:22.04 AS build

ARG APT_PROXY
ARG HDHOMERUN_VERSION=20231214
ENV DEBIAN_FRONTEND=noninteractive

RUN if [ -n "${APT_PROXY}" ]; then echo "Acquire::HTTP::Proxy \"${APT_PROXY}\";\nAcquire::HTTPS::Proxy false;\n" >> /etc/apt/apt.conf.d/01proxy; cat /etc/apt/apt.conf.d/01proxy; fi && \
    apt-get -q update && \
    apt-get -y install build-essential libgtk2.0-dev &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -f /etc/apt/apt.conf.d/01proxy &&\
    rm -rf /tmp/*

# https://www.silicondust.com/support/linux/
ADD https://download.silicondust.com/hdhomerun/libhdhomerun_${HDHOMERUN_VERSION}.tgz /usr/src/
ADD https://download.silicondust.com/hdhomerun/hdhomerun_config_gui_${HDHOMERUN_VERSION}.tgz /usr/src/

RUN cd /usr/src &&\
    tar xzf libhdhomerun_${HDHOMERUN_VERSION}.tgz &&\
    tar xzf hdhomerun_config_gui_${HDHOMERUN_VERSION}.tgz &&\
    cd /usr/src/hdhomerun_config_gui &&\
    ./configure &&\
    make

FROM ubuntu:22.04

ARG APT_PROXY
ARG HDHOMERUN_FIRMWARE=20231214
ENV DEBIAN_FRONTEND=noninteractive

RUN if [ -n "${APT_PROXY}" ]; then echo "Acquire::HTTP::Proxy \"${APT_PROXY}\";\nAcquire::HTTPS::Proxy false;\n" >> /etc/apt/apt.conf.d/01proxy; cat /etc/apt/apt.conf.d/01proxy; fi && \
    apt-get -q update && \
    apt-get -y install build-essential perl &&\
    cpan JSON &&\
    cpan LWP &&\
    cpan find &&\
    apt-get -y remove build-essential &&\
    apt-get -y auto-remove &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -f /etc/apt/apt.conf.d/01proxy &&\
    rm -rf /tmp/*

ADD https://download.silicondust.com/hdhomerun/hdhomerun_atsc_firmware_20210422.bin /opt/
ADD https://download.silicondust.com/hdhomerun/hdhomerun3_atsc_firmware_20210422.bin /opt/
ADD https://download.silicondust.com/hdhomerun/hdhomerun3_cablecard_firmware_20210422.bin /opt/
ADD https://download.silicondust.com/hdhomerun/hdhomerun4_atsc_firmware_20210422.bin /opt/
ADD https://download.silicondust.com/hdhomerun/hdhomeruntc_atsc_firmware_20210422.bin /opt/
ADD https://download.silicondust.com/hdhomerun/hdhomerun5_atsc_firmware_${HDHOMERUN_FIRMWARE}.bin /opt/
ADD https://download.silicondust.com/hdhomerun/hdhomerun_dvr_atsc_firmware_${HDHOMERUN_FIRMWARE}.bin /opt/
ADD https://download.silicondust.com/hdhomerun/hdhomerun_dvr_atsc3_firmware_${HDHOMERUN_FIRMWARE}.bin /opt/

COPY --from=build /usr/src/libhdhomerun/hdhomerun_config /usr/bin/

# https://markjcolombo.com/scan_tuner.txt with modifications
COPY scan_tuner.pl /usr/bin/
COPY entrypoint.sh healthcheck.sh /
RUN chmod +x /entrypoint.sh /healthcheck.sh /usr/bin/scan_tuner.pl
VOLUME /data

CMD [ "/entrypoint.sh" ]
HEALTHCHECK CMD /healthcheck.sh
