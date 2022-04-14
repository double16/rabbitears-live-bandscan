#!/usr/bin/env bash

exec /usr/bin/scan_tuner.pl \
    ${DEBUG:+-d} \
    -t /${TUNER:-tuner0}/ \
    ${TUNER_ID:+-x ${TUNER_ID}} \
    ${TUNER_ADDR:+-n ${TUNER_ADDR}} \
    ${URL:+-u ${URL}} \
    ${DATA_DIR:+-w ${DATA_DIR}}
