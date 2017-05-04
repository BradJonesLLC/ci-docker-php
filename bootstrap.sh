#!/bin/bash

. /set-docker-group.sh

chroot --userspec runner / "$@"
