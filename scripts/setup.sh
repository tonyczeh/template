#!/usr/bin/env bash
# Set up dev environment for the first time after cloning or
# reset environment to pristine state.
set -e

# Grab the user's PWD so we can put them back
OG_PWD=$PWD

# Pull in constants and other helpers
source "$(dirname "$0")/constants.sh"

# Ensure we can find the tools we need
section 'Checking for required tools'
COMMANDS=('awk' 'git' 'vagrant' 'VBoxManage')
for cmd in "${COMMANDS[@]}"; do
    command -v $cmd >/dev/null 2>&1 || {
        err "'${cmd}' is not installed or available on my PATH."
        exit 1
    }
done
info 'Done'

section 'Configuring vagrant'
cd "${DEVELOPMENT_ROOT}"
# Destroy vagrant box if it exists
VAGRANT_BOX_ROOT="${DEVELOPMENT_ROOT}/.vagrant/machines/default/virtualbox"
if [ -d "$VAGRANT_BOX_ROOT" ] && [ "$(ls -A "$VAGRANT_BOX_ROOT")" ]; then
    info 'Destroying existing vagrant box'
    vagrant destroy -f
fi

info 'Creating Vagrantfile'
PROJECT_ROOT=${PROJECT_ROOT} \
APP_USER_UID=${APP_USER_UID} \
awk '{
    while(match($0,"[$]{[^}]*}")) {
        var=substr($0,RSTART+2,RLENGTH -3);
        gsub("[$]{"var"}",ENVIRON[var])
    }
}1' < "${DEVELOPMENT_ROOT}/Vagrantfile.template" > "${DEVELOPMENT_ROOT}/Vagrantfile"

info 'Starting vagrant box'
vagrant up || {
    EXIT=$?
    rm -rf ${DEVELOPMENT_ROOT}/.vagrant
    exit $EXIT
}
info 'Done'

# Provisioning OS
vagrant ssh -c "sudo -H ${PROJECT_ROOT}/scripts/provision_os.sh" || {
    err 'Provision OS failed'
    exit 2
}

# Provisioning Code
vagrant ssh -c "sudo -Hu ${APP_USER} ${PROJECT_ROOT}/scripts/provision_code.sh" || {
    err 'Provision code failed'
    exit 4
}

# Provisioning Services
vagrant ssh -c "sudo -H ${PROJECT_ROOT}/scripts/provision_services.sh" || {
    err 'Provision services failed'
    exit 8
}

cd "${OG_PWD}"
section 'The development environment is ready.'
info 'SSH into the development environment by running:'
info "cd ${DEVELOPMENT_ROOT} && vagrant ssh"
info "The application username is '${APP_USER}'"
info "Code is available at ${PROJECT_ROOT}"
