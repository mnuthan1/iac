#!/bin/bash

## script to overwrite spinnaker service images

tee /root/.hal/default/profiles/gate-local.yml <<-'EOF'
server:
  servlet:
    context-path: /api/v1
EOF

tee /root/.hal/default/service-settings/gate.yml <<-'EOF'
healthEndpoint: /api/v1/health
EOF


tee /root/.hal/default/service-settings/front50.yml <<-'EOF'
artifactId: docker.io/mnuthan/front50
EOF