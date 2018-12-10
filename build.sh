#!/usr/bin/env bash
set -euxo pipefail

docker build . -t java-saturation
