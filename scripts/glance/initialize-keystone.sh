#!/bin/bash
set -x

SERVICE_NAME=glance
SERVICE_TYPE=image
SERVICE_DESCRIPTION="OpenStack Image Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=https://${CONTROL_HOST_IP}:9292
PRIVATE_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:9292
ADMIN_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:9292

/scripts/common/initialize-keystone "${SERVICE_NAME}" \
                                    "${SERVICE_TYPE}" \
                                    "${SERVICE_DESCRIPTION}" \
                                    "${SERVICE_PASSWORD}" \
                                    "${PUBLIC_ENDPOINT}" \
                                    "${PRIVATE_ENDPOINT}" \
                                    "${ADMIN_ENDPOINT}"
