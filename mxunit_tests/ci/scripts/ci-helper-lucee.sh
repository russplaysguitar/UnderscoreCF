#!/bin/bash
case $1 in
    start)
        CONTROL_SCRIPT='./startup.sh'
        ;;
    stop)
        CONTROL_SCRIPT='./shutdown.sh'
        ;;
esac

PLATFORM_DIR="lucee"
WEBROOT="webapps/ROOT"
MY_DIR=`dirname $0`
source $MY_DIR/ci-helper-base.sh $1 $2

case $1 in
    install)
        chmod a+x ./startup.sh
        chmod a+x ./shutdown.sh
        ;;
    start|stop)
        ;;
    *)
        echo "Usage: $0 {install|start|stop}"
        exit 1
        ;;
esac

exit 0
