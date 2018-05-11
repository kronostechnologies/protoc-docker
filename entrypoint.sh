#!/bin/bash

[[ -n $(getent group "${GROUPID}") ]] && getent group ${GROUPID} | awk -F: '{ print $1 }' |xargs delgroup

groupadd -o -g ${GROUPID:-1000} docker
useradd -o -d /code/.protoc-docker -u ${USERID:-1000} -g docker -M docker

exec sudo -u docker protoc-wrapper.sh "$@"