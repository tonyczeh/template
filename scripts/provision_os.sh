#!/usr/bin/env bash
# Assuming a pristine machine, perform minimal OS setup to allow
# code to be deployed.
set -e

# Pull in constants and other helpers
source "$(dirname "$0")/constants.sh"

if [ $UID -ne 0 ]; then
    err 'Boldly refusing to NOT run as root!'
    exit 1
fi

section 'Provisioning OS'
info 'Syncing package tree'
emaint -A sync || {
    err 'Package tree sync failed'
    exit 2
}

info "Adding user ${APP_USER_NAME}(${APP_USER})"
useradd -MU \
    -c "${APP_USER_NAME}" \
    -d "${APP_USER_HOME}" \
    -u ${APP_USER_UID} \
    ${APP_USER} \
|| {
    err 'User creation failed'
    exit 4
}

for group in "${APP_USER_EXTRA_GROUPS[@]}"; do
    info "Adding user to group ${group}"
    gpasswd -a ${APP_USER} ${group} || {
        err 'Group add failed'
        exit 8
    }
done

info "Populating ${APP_USER_HOME}"
rsync -avP /etc/skel/ ${APP_USER_HOME}

info 'Fixing permissions'
chown -R ${APP_USER}:${APP_USER} ${APP_USER_HOME}

info 'Done'
