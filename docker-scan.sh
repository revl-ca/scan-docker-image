#!/usr/bin/env bash

set -e

# Usage: SCANNER_TOKEN="<TOKEN>" SCANNER_IMAGE="<IMAGE>" ./docker-scan.sh [--silent,--quiet,-s,-q]

SCANNER_IMAGE=${SCANNER_IMAGE:?The source image not set.}
SCANNER_TOKEN=${SCANNER_TOKEN:?AquaSec MicroScanner TOKEN not found.}
SCANNER_ARG=""

IMAGE_NAME=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)

if [[ "$1" =~ ^--silent|^--quiet|^-s|^-q ]]; then
  SCANNER_ARG=${SCANNER_ARG:=--continue-on-failure}

  echo -en "[Silent] Scanning $SCANNER_IMAGE:\n\n"
else
  echo -en "Scanning $SCANNER_IMAGE:\n\n"
fi


docker image build \
  --build-arg SCANNER_IMAGE=$SCANNER_IMAGE \
  --build-arg SCANNER_TOKEN=$SCANNER_TOKEN \
  --build-arg SCANNER_ARG=$SCANNER_ARG \
  --file Dockerfile-scan \
  --tag $IMAGE_NAME \
  .

docker image rm $IMAGE_NAME

