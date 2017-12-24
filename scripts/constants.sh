# Constants
APP_USER=app
APP_USER_EXTRA_GROUPS=()
APP_USER_NAME='Application User'
APP_USER_HOME=/home/app
APP_USER_UID=60000

PROJECT_ROOT="${APP_USER_HOME}/code"

# Absolute path to development root
OLD_PWD=$PWD
cd "$(dirname "$0")/.."
DEVELOPMENT_ROOT=$PWD
cd $OLD_PWD
unset OLD_PWD

# Output helpers
section() { printf "%b\n" "\e[92m******* $@ *******\e[0m"; }
info() { printf "%b\n" "\t\e[96m$@\e[0m"; }
err() { printf "%b\n" "\t\e[91m$@\e[0m" 1>&2; }

# Print variables we rely on for debugging when things break
section "ENVIRONMENT VARIABLES FOR: $0"
info "APP_USER: $APP_USER"
info "APP_USER_EXTRA_GROUPS: $APP_USER_EXTRA_GROUPS"
info "APP_USER_NAME: $APP_USER_NAME"
info "APP_USER_HOME: $APP_USER_HOME"
info "APP_USER_UID: $APP_USER_UID"
info "DEVELOPMENT_ROOT: $DEVELOPMENT_ROOT"
info "PROJECT_ROOT: $PROJECT_ROOT"
