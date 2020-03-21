export PATH=/home/spinnaker:$PATH

ADDRESS=index.docker.io
REPOSITORIES=library/nginx 
hal config provider docker-registry enable
hal config provider docker-registry account add my-docker-registry \
   --address $ADDRESS \
   --repositories $REPOSITORIES

export POD_NAME=$(kubectl get pods --namespace default -l "release=minio" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 9000 --namespace default&
export ENDPOINT=127.0.0.1:9000


# setup storage for HAL
echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint $ENDPOINT \
   --access-key-id $MINIO_ACCESS_KEY \
   --secret-access-key
hal config storage edit --type s3

hal config provider kubernetes enable
hal config provider kubernetes account add my-k8s-account --docker-registries my-docker-registry
hal config deploy edit --type distributed --account-name my-k8s-account

hal config version edit --version 1.18.4

hal deploy apply
