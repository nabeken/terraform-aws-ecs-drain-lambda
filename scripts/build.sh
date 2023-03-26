#!/bin/sh
VERSION=1.0.7

set -e

curl -sSL --fail -O "https://github.com/getsocial-rnd/ecs-drain-lambda/releases/download/v${VERSION}/ecs-drain-lambda_${VERSION}_checksums.txt"
curl -sSL --fail -O "https://github.com/getsocial-rnd/ecs-drain-lambda/releases/download/v${VERSION}/ecs-drain-lambda_${VERSION}_linux_amd64.zip"

shasum --check ecs-drain-lambda_1.0.7_checksums.txt
