#!/bin/bash

set -ex

### Setup for the build

# make the submodule as normal git repo
rm -rf src/.git
#cp -aR ../../.git/modules/spin-services/front50/src src/.git
#sed -i '/worktree/d' src/.git/src/config

### Build
PROVIDERS=redis,swift,gcs,s3
pushd src

# they grab the sdk from github.com and do evil things to it,
# -PincludeProviders configures front50-web, but the module will still get compiled
rm -rf front50-oracle || true

# this test reaches out to internet so excluding it
echo "test { exclude '**/SqlStorageServiceTests.class' }" >> front50-sql/front50-sql.gradle

# build
gradle -PincludeProviders=${PROVIDERS} -Dhttps.proxyHost=${HTTP_PROXY_HOST} -Dhttps.proxyPort=${HTTP_PROXY_PORT} -Dhttp.nonProxyHosts="${HTTP_PROXY_BYPASS}" build --stacktrace


docker build . -t front50
docker tag front50 mnuthan/front50
docker push mnuthan/front50

#hal deploy apply --service-names=front50