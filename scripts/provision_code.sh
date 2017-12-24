#!/usr/bin/env bash
# Assuming a minimal system with code properly deployed and OS requirements met,
# perform any additional configuration needed.
set -e

# Pull in constants and other helpers
source "$(dirname "$0")/constants.sh"

if [ $UID -ne $APP_USER_UID ]; then
    err "Boldly refusing to NOT run as ${APP_USER_NAME}(${APP_USER_UID})!"
    exit 1
fi

section 'Provisioning code'
info 'Done'
