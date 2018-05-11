#!/usr/bin/env bash

set -e

PROTOC_ARGS=()
TARGET=""

# Detect target language and add corresponding grpc plugin

while [[ $# -gt 0 ]]
do
  key="$1"
  if [ "$TARGET" == "" ]; then
    TARGET=`expr match "$key" '--\(.*\)_out' || true`
  fi
  PROTOC_ARGS+=("$1") # save it in an array for later
  shift
done

if [ "$TARGET" != "" ]; then
  PLUGIN_NAME="grpc_${TARGET}_plugin"
  PLUGIN_PATH=`which $PLUGIN_NAME`
  if [ -x "$PLUGIN_PATH" ]; then
    PROTOC_ARGS+=("--plugin=protoc-gen-grpc=$PLUGIN_PATH")
  fi
fi

if [ "${#PROTOC_ARGS[@]:0}" -gt 0 ]; then
	protoc "${PROTOC_ARGS[@]}"
else
	protoc
fi
