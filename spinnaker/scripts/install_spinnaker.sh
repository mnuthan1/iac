#!/bin/bash

export PATH=/home/spinnaker:$PATH

ADDRESS=index.docker.io
REPOSITORIES=library/nginx 
hal config provider docker-registry enable
hal config provider docker-registry account add my-docker-registry \
   --address $ADDRESS \
   --repositories $REPOSITORIES

#export POD_NAME=$(kubectl get pods --namespace default -l "release=minio" -o jsonpath="{.items[0].metadata.name}")
#kubectl port-forward $POD_NAME 9000 --namespace default&
export MINIO_IP=$(kubectl get svc --namespace default -l "release=minio" -o jsonpath="{.items[0].spec.clusterIP}")
export MINIO_PORT=$(kubectl get svc --namespace default -l "release=minio" -o jsonpath="{.items[0].spec.ports[0].port}")
export ENDPOINT=${MINIO_IP}:${MINIO_PORT}

## using secrets
#export MINIO_ACCESS_KEY=minioaccess
#export MINIO_SECRET_KEY=miniosecret
# setup storage for HAL
echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint $ENDPOINT \
   --access-key-id $MINIO_ACCESS_KEY \
   --secret-access-key
hal config storage edit --type s3

hal config provider kubernetes enable

hal config provider kubernetes account add spinnaker \
  --provider-version v2 \
  --only-spinnaker-managed true \
  --service-account true \
  --namespaces spinnaker \
  --docker-registries my-docker-registry

hal config provider kubernetes account edit spinnaker \
  --namespaces spinnaker,dev,stage,prod 

hal config deploy edit --type distributed --account-name spinnaker


### overwrite service settings and profiles
mkdir -p /root/.hal/default/{profiles,service-settings}

tee /root/.hal/default/profiles/gate-local.yml <<-'EOF'
server:
  servlet:
    context-path: /api/v1
EOF

tee /root/.hal/default/service-settings/gate.yml <<-'EOF'
healthEndpoint: /api/v1/health
EOF

tee /root/.hal/default/service-settings/gate.yml <<-'EOF'
healthEndpoint: /api/v1/health
EOF
tee /root/.hal/default/service-settings/front50.yml <<-'EOF'
artifactId: docker.io/mnuthan/front50
EOF



export VERSION=$(hal version latest -q)
echo ${VERSION}
hal config version edit --version ${VERSION}


hal deploy apply --wait-for-completion
