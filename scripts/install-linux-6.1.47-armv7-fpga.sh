#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
REPO_DIR=$(cd $(dirname $0); cd .. ; pwd)
KERNEL_VERSION=6.1.47
LOCAL_VERSION=armv7-fpga
BUILD_VERSION=1

. "$SCRIPT_DIR/install-variables-armv7-fpga.sh"
. "$SCRIPT_DIR/install-command.sh"
