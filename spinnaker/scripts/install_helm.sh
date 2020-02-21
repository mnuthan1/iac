##
# script to install helm on a pod
#####
apk --update add --no-cache openssl
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod +x get_helm.sh
sed -i 's/\/usr\/local\/bin/\/home\/spinnaker/g' get_helm.sh
sed -i 's/sudo //g' get_helm.sh
export PATH=/home/spinnaker:$PATH

./get_helm.sh

# add minio repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
# iinstall minio
#This chart provisions a PersistentVolumeClaim and mounts corresponding persistent volume to default location /export. You'll need physical storage available in the Kubernetes cluster for this to work. If you'd rather use emptyDir, disable PersistentVolumeClaim by
# diable persistence
# reference : https://github.com/helm/charts/tree/master/stable/minio
export MINIO_ACCESS_KEY=minioaccess
export MINIO_SECRET_KEY=miniosecret

helm upgrade --install --set accessKey=${MINIO_ACCESS_KEY},secretKey=${MINIO_SECRET_KEY},persistence.enabled=false \
    minio stable/minio

