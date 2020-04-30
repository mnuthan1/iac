#!/bin/bash

set -ex
### Build
pushd src
gradle --no-daemon -PenableCrossCompilerPlugin=true front50-web:installDist -x test

