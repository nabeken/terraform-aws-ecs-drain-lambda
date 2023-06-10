#!/bin/bash
APP=ecs-drain-lambda
VERSION=1.0.7

set -eo pipefail

T=$(mktemp -d)
trap "rm -rf ${T}" EXIT

pushd "${T}"

curl -sSL --fail -O "https://github.com/getsocial-rnd/${APP}/releases/download/v${VERSION}/${APP}_${VERSION}_checksums.txt"
curl -sSL --fail -O "https://github.com/getsocial-rnd/${APP}/releases/download/v${VERSION}/${APP}_${VERSION}_linux_amd64.zip"

shasum --check "${APP}_${VERSION}_checksums.txt"

echo "renaming the binary to 'bootstrap'..."

unzip "${APP}_${VERSION}_linux_amd64.zip"
cp -a ${APP} bootstrap
zip "${APP}_${VERSION}_linux_amd64.zip" bootstrap
zip "${APP}_${VERSION}_linux_amd64.zip" -d ${APP}

popd

mv "${T}/${APP}_${VERSION}_linux_amd64.zip" .
