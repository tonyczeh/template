#!/usr/bin/env bash
# Assuming a minimal system with code properly deployed, OS requirements met,
# and code properly configured, finalize configuration and running status of
# all services.
set -e

# Pull in constants and other helpers
source "$(dirname "$0")/constants.sh"

if [ $UID -ne 0 ]; then
    err 'Boldly refusing to NOT run as root!'
    exit 1
fi

section 'Provisioning services'
info 'Done'
